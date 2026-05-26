#!/usr/bin/env bash
#
# Hook PostToolUse · variante B (augmenter)
#
# Déclenché après chaque appel Bash. Filtre les `git commit`, récupère le
# diff du commit qui vient d'être fait, lance security-review, attache le
# rapport en git note (visible avec `git log --show-notes`).

set -uo pipefail

EVENT=$(cat)
TOOL=$(echo "$EVENT" | jq -r '.tool_name        // ""')
CMD=$(echo "$EVENT"  | jq -r '.tool_input.command // ""')

[[ "$TOOL" == "Bash" ]] || exit 0
[[ "$CMD" =~ ^git[[:space:]]+commit ]] || exit 0

# Vérifier qu'un commit a bien été créé
COMMIT=$(git rev-parse --short HEAD 2>/dev/null) || exit 0

# Récupérer le diff du dernier commit
DIFF=$(git show "$COMMIT" --no-color 2>/dev/null)
[[ -z "$DIFF" ]] && exit 0

# Lancer security-review en headless
REPORT=$(echo "$DIFF" | claude -p \
  "Lance security-review sur ce commit. Retourne uniquement le rapport markdown." \
  --output-format text 2>/dev/null)

[[ -z "$REPORT" ]] && exit 0

# Attacher en git note
git notes add -f -m "$REPORT" HEAD 2>/dev/null || true

echo "[security-review] rapport attaché au commit $COMMIT (voir 'git log --show-notes')." >&2
exit 0
