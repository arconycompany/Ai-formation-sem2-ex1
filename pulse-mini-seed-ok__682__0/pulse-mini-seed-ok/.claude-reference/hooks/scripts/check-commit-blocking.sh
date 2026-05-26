#!/usr/bin/env bash
#
# Hook PreToolUse · variante A (bloquer)
#
# Déclenché avant chaque appel Bash. Filtre les `git commit`, récupère le
# diff stagé, invoque le sub-agent security-review, refuse le commit
# (exit 2) si le rapport contient [BLOQUANT].
#
# Prérequis : jq, claude CLI authentifié, sub-agent security-review présent.

set -uo pipefail

EVENT=$(cat)
TOOL=$(echo "$EVENT"  | jq -r '.tool_name        // ""')
CMD=$(echo "$EVENT"   | jq -r '.tool_input.command // ""')

# On ne s'intéresse qu'aux git commit
[[ "$TOOL" == "Bash" ]] || exit 0
[[ "$CMD" =~ ^git[[:space:]]+commit ]] || exit 0

# Récupérer le diff stagé
DIFF=$(git diff --cached 2>/dev/null)
[[ -z "$DIFF" ]] && exit 0

# Invoquer le sub-agent en mode headless
REPORT=$(echo "$DIFF" | claude -p \
  "Lance le sub-agent security-review sur ce diff stagé. Retourne uniquement son rapport markdown." \
  --output-format text 2>/dev/null)

# Si l'invocation a échoué, on ne bloque pas (fail-open) mais on prévient
if [[ -z "$REPORT" ]]; then
  echo "[security-review] avertissement : impossible d'invoquer le sub-agent, commit autorisé sans revue." >&2
  exit 0
fi

# Décision
if echo "$REPORT" | grep -q "\[BLOQUANT\]" && \
   ! echo "$REPORT" | grep -A1 "^## \[BLOQUANT\]" | grep -q "^Aucun"; then
  cat >&2 <<EOF

╔════════════════════════════════════════════════════════════════╗
║  COMMIT REFUSÉ — security-review a détecté un BLOQUANT         ║
╚════════════════════════════════════════════════════════════════╝

$REPORT

Corrige les findings [BLOQUANT] puis retente le commit.
EOF
  exit 2
fi

# Pas de bloquant : on laisse passer, on affiche un résumé court
echo "[security-review] commit autorisé." >&2
if echo "$REPORT" | grep -qE "\[WARN\]" && \
   ! echo "$REPORT" | grep -A1 "^## \[WARN\]" | grep -q "^Aucun"; then
  echo "[security-review] des [WARN] sont présents, à traiter en suivant." >&2
fi

exit 0
