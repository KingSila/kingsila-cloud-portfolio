#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------
# Argument Parsing
# -----------------------------------
HOURS=""
WEEK=""
NOTES=""
TASKS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --hours|-h)
      HOURS="$2"
      shift 2
      ;;
    --week|-w)
      WEEK="$2"
      shift 2
      ;;
    --tasks|-t)
      shift
      while [[ $# -gt 0 && "$1" != --* ]]; do
        TASKS+=("$1")
        shift
      done
      ;;
    --notes|-n)
      NOTES="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$HOURS" || -z "$WEEK" || ${#TASKS[@]} -eq 0 ]]; then
  echo "Usage: ./quick-update.sh --hours 3 --week 1 --tasks \"Task1\" \"Task2\" [--notes \"text\"]"
  exit 1
fi

if ! command -v jq >/dev/null; then
  echo "jq is required. Please install jq."
  exit 1
fi

TODAY="$(date +%F)"
PROGRESS_FILE="progress.json"

# -----------------------------------
# Week Mapping
# -----------------------------------
case "$WEEK" in
  1) CURRENT_WEEK="week1-2" ;;
  2) CURRENT_WEEK="week3-4" ;;
  3) CURRENT_WEEK="week5-6" ;;
  4) CURRENT_WEEK="week7-8" ;;
  5) CURRENT_WEEK="week9-10" ;;
  6) CURRENT_WEEK="week11-12" ;;
  *) echo "Invalid week: must be 1–6"; exit 1 ;;
esac

# Convert tasks array → JSON array
TASKS_JSON=$(printf '%s\n' "${TASKS[@]}" | jq -R . | jq -s .)

# -----------------------------------
# 1. Remove existing entry for today
# 2. Add new entry
# -----------------------------------
tmpfile=$(mktemp)

jq \
  --arg date "$TODAY" \
  --arg week "$CURRENT_WEEK" \
  --arg hours "$HOURS" \
  --arg notes "$NOTES" \
  --argjson tasks "$TASKS_JSON" \
'
  # Remove today's entry
  .dailyLogs |= map(select(.date != $date))

  # Add new entry
  | .dailyLogs += [{
      date: $date,
      week: $week,
      hoursSpent: ($hours | tonumber),
      tasksCompleted: $tasks,
      challenges: [],
      learnings: [],
      notes: $notes
    }]
' "$PROGRESS_FILE" > "$tmpfile"

mv "$tmpfile" "$PROGRESS_FILE"

# -----------------------------------
# Update weekly totals and tasks
# -----------------------------------
tmpfile=$(mktemp)

jq \
  --arg week "$CURRENT_WEEK" \
  --arg hours "$HOURS" \
  --argjson tasks "$TASKS_JSON" \
'
  # Add hours
  .weeklyProgress[$week].hoursSpent += ($hours | tonumber)

  # Add unique tasks
  .weeklyProgress[$week].tasksCompleted |= (. + $tasks | unique)

  # Mark week active
  | if .weeklyProgress[$week].status == "not-started"
    then .weeklyProgress[$week].status = "in-progress"
    else .
    end
' "$PROGRESS_FILE" > "$tmpfile"

mv "$tmpfile" "$PROGRESS_FILE"

# -----------------------------------
# Update streak (last 7 days)
# -----------------------------------
SEVEN_DAYS_AGO=$(date -d "-7 days" +%F)

tmpfile=$(mktemp)

jq --arg seven "$SEVEN_DAYS_AGO" '
  .badges.weeklyStreak =
    (.dailyLogs | map(select(.date >= $seven)) | length)
' "$PROGRESS_FILE" > "$tmpfile"

mv "$tmpfile" "$PROGRESS_FILE"

# -----------------------------------
# Final Output
# -----------------------------------
echo "✅ Quick update saved for $TODAY"
echo "⏱️  Hours: $HOURS | 📋 Tasks: ${#TASKS[@]}"
echo "💾 progress.json updated"
echo
echo "💡 Commit suggestion:"
echo "   git add progress.json"
echo "   git commit -m \"Quick update: $TODAY\""
