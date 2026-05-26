#!/bin/bash
# Claude Code statusLine command
# Format: model · branch · $cost · ctx Y% [CAVEMAN]

input=$(cat)

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // empty')
[ -n "$model" ] && model_part=$(printf '\033[36m%s\033[0m' "$model") || model_part=""

# --- Git branch ---
cwd=$(echo "$input" | jq -r '.cwd // empty')
[ -z "$cwd" ] && cwd=$(pwd)
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
[ -n "$branch" ] && branch_part=$(printf '\033[33m%s\033[0m' "$branch") || branch_part=""

# --- Session cost ---
cost=$(echo "$input" | jq -r '.session_cost // empty')
if [ -n "$cost" ]; then
  cost_fmt=$(printf '%.4f' "$cost" 2>/dev/null)
  cost_part=$(printf '\033[35m$%s\033[0m' "$cost_fmt")
else
  cost_part=""
fi

# --- Context usage ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  if [ "$used_int" -ge 80 ]; then
    ctx_color='\033[31m'
  elif [ "$used_int" -ge 50 ]; then
    ctx_color='\033[33m'
  else
    ctx_color='\033[32m'
  fi
  ctx_part=$(printf "${ctx_color}ctx %s%%\033[0m" "$used_int")
else
  ctx_part=""
fi

# --- Caveman badge ---
FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
caveman_part=""
if [ ! -L "$FLAG" ] && [ -f "$FLAG" ]; then
  MODE=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]')
  MODE=$(printf '%s' "$MODE" | tr -cd 'a-z0-9-')
  case "$MODE" in
    off|lite|full|ultra|wenyan-lite|wenyan|wenyan-full|wenyan-ultra|commit|review|compress)
      if [ -z "$MODE" ] || [ "$MODE" = "full" ]; then
        caveman_part=$(printf '\033[38;5;172m[CAVEMAN]\033[0m')
      else
        SUFFIX=$(printf '%s' "$MODE" | tr '[:lower:]' '[:upper:]')
        caveman_part=$(printf '\033[38;5;172m[CAVEMAN:%s]\033[0m' "$SUFFIX")
      fi
      ;;
  esac
fi

# --- Assemble: model · branch · $cost · ctx Y% [CAVEMAN] ---
SEP=$(printf ' \033[90m·\033[0m ')
result=""
for part in "$model_part" "$branch_part" "$cost_part" "$ctx_part" "$caveman_part"; do
  [ -z "$part" ] && continue
  if [ -z "$result" ]; then
    result="$part"
  else
    result="$result$SEP$part"
  fi
done

printf '%b' "$result"
