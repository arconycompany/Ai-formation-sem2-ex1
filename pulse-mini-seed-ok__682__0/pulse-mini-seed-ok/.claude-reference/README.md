# Reference — Exercice 2 (formateur)

Solutions de référence à dégainer si un trinôme galère sur l'Exercice 2 du J4.

À **NE PAS distribuer** aux élèves d'office — ils doivent construire ces
fichiers eux-mêmes. Sortir cette référence uniquement en débloquage.

## Contenu

- `agents/security-review.md` — sub-agent qu'ils doivent créer
- `hooks/scripts/check-commit-blocking.sh` — variante A (bloque le commit)
- `hooks/scripts/augment-commit.sh` — variante B (annote en git note)
- `hooks/scripts/session-log.sh` — hook Stop pour le session-log
- `settings.example.json` — exemple de wiring complet

## Installation chez un trinôme bloqué

```bash
# Depuis pulse-mini-seed/
mkdir -p .claude/agents .claude/hooks/scripts
cp .claude-reference/agents/security-review.md .claude/agents/
cp .claude-reference/hooks/scripts/*.sh .claude/hooks/scripts/
chmod +x .claude/hooks/scripts/*.sh
cp .claude-reference/settings.example.json .claude/settings.json
```

Puis relancer Claude Code dans le repo. Test rapide :

```bash
echo "const KEY='sk-test-123456789012345678901';" > services/tickets-api/src/oops.js
git add services/tickets-api/src/oops.js
# demander à Claude : "fais un git commit -m 'test'"
# → le hook variante A doit bloquer avec un message d'erreur lisible
```

## Prérequis pour que les hooks marchent

- `jq` installé (parsing de l'event JSON sur stdin)
- `claude` CLI dans le PATH et authentifié (invocation du sub-agent en
  mode headless via `claude -p "..."`)
- Sub-agent `security-review` présent dans `.claude/agents/`

## Caveat pédagogique

Invoquer `claude -p` depuis un hook crée une **session distincte** et
consomme des tokens. Pour un usage production, on remplacerait par un
appel direct à l'API Anthropic via le SDK, avec cache et batch. C'est
l'objet du J9 (pipeline CI/CD).
