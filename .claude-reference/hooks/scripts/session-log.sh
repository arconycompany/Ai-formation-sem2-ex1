#!/usr/bin/env bash
#
# Hook Stop · session-log
#
# Déclenché en fin de session Claude Code. Append un résumé de la session
# (branche, commits récents, id session) à .claude/session-log.md.
# Le fichier est gitignoré (cf .gitignore racine).

set -uo pipefail

EVENT=$(cat)
SESSION_ID=$(echo "$EVENT" | jq -r '.session_id // "unknown"')

LOG_DIR=".claude"
LOG_FILE="$LOG_DIR/session-log.md"
mkdir -p "$LOG_DIR"

{
  echo ""
  echo "## Session $(date '+%Y-%m-%d %H:%M') · ${SESSION_ID:0:8}"
  echo ""
  echo "- **Branche** : $(git branch --show-current 2>/dev/null || echo 'n/a')"
  echo "- **CWD** : $(pwd)"
  echo ""
  echo "### 5 commits les plus récents"
  echo ""
  git log --oneline -5 2>/dev/null | sed 's/^/- /' || echo "_aucun commit_"
  echo ""
  echo "---"
} >> "$LOG_FILE"

exit 0
