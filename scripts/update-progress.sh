#!/usr/bin/env bash

# update-progress.sh
# Usage: ./update-progress.sh

set -euo pipefail

PROGRESS_FILE="progress.json"
TODAY="$(date +%F)"

if [[ ! -f "$PROGRESS_FILE" ]]; then
  echo "progress.json not found in current directory."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed. Please install jq and retry."
  exit 1
fi

# ------------------------------------------------------------------------------
# Check if today's entry already exists
# ------------------------------------------------------------------------------

EXISTING_ENTRY="$(jq --arg d "$TODAY" '.dailyLogs[]? | select(.date == $d)' "$PROGRESS_FILE" || true)"

if [[ -n "$EXISTING_ENTRY" ]]; then
  echo "⚠️  Entry for $TODAY already exists. Update it? (y/n)"
  read -r UPDATE
  if [[ "$UPDATE" != "y" ]]; then
    echo "❌ Update cancelled."
    exit 0
  fi

  # Remove today's entry from dailyLogs
  tmpfile="$(mktemp)"
  jq --arg d "$TODAY" '.dailyLogs |= map(select(.date != $d))' "$PROGRESS_FILE" > "$tmpfile"
  mv "$tmpfile" "$PROGRESS_FILE"
fi

echo
echo "📅 Daily Progress Update - $TODAY"
printf '%0.s═' {1..40}
echo

# ------------------------------------------------------------------------------
# Week selection
# ------------------------------------------------------------------------------

echo
echo "📌 Which week are you working on?"
echo "   1. week1-2: Azure Core + Governance"
echo "   2. week3-4: Terraform Advanced"
echo "   3. week5-6: CI/CD & Automation"
echo "   4. week7-8: Security & Monitoring"
echo "   5. week9-10: Containers & Modern Infra"
echo "   6. week11-12: Portfolio & Interview Readiness"
read -rp "Enter number (1-6): " WEEK_CHOICE

case "$WEEK_CHOICE" in
  1) CURRENT_WEEK="week1-2" ;;
  2) CURRENT_WEEK="week3-4" ;;
  3) CURRENT_WEEK="week5-6" ;;
  4) CURRENT_WEEK="week7-8" ;;
  5) CURRENT_WEEK="week9-10" ;;
  6) CURRENT_WEEK="week11-12" ;;
  *)
    echo "Invalid week choice."
    exit 1
    ;;
esac

# ------------------------------------------------------------------------------
# Hours spent
# ------------------------------------------------------------------------------

echo
read -rp "⏱️  Hours spent today: " HOURS_SPENT

# basic sanity check
if ! [[ "$HOURS_SPENT" =~ ^[0-9]+$ ]]; then
  echo "Hours must be a whole number."
  exit 1
fi

# ------------------------------------------------------------------------------
# Multi-line input helpers
# ------------------------------------------------------------------------------

read_multiline() {
  local label="$1"
  local -n _out_array="$2"

  echo
  echo "$label (one per line, press Enter on empty line to finish):"
  while true; do
    read -rp "  - " line
    [[ -z "$line" ]] && break
    _out_array+=("$line")
  done
}

TASKS=()
CHALLENGES=()
LEARNINGS=()

read_multiline "✅ Tasks completed today" TASKS
read_multiline "🚧 Challenges faced" CHALLENGES
read_multiline "🧠 Key learnings" LEARNINGS

echo
read -rp "📝 Additional notes: " NOTES

# ------------------------------------------------------------------------------
# Build JSON arrays for tasks/challenges/learnings
# ------------------------------------------------------------------------------

array_to_json() {
  # prints JSON array from bash array
  local -n arr="$1"
  if ((${#arr[@]} == 0)); then
    echo '[]'
  else
    printf '%s\n' "${arr[@]}" | jq -R . | jq -s .
  fi
}

TASKS_JSON="$(array_to_json TASKS)"
CHALLENGES_JSON="$(array_to_json CHALLENGES)"
LEARNINGS_JSON="$(array_to_json LEARNINGS)"

# ------------------------------------------------------------------------------
# Build new daily log entry
# ------------------------------------------------------------------------------

NEW_LOG="$(jq -n \
  --arg date "$TODAY" \
  --arg week "$CURRENT_WEEK" \
  --arg hours "$HOURS_SPENT" \
  --arg notes "$NOTES" \
  --argjson tasks "$TASKS_JSON" \
  --argjson challenges "$CHALLENGES_JSON" \
  --argjson learnings "$LEARNINGS_JSON" \
  '{
    date: $date,
    week: $week,
    hoursSpent: ($hours | tonumber),
    tasksCompleted: $tasks,
    challenges: $challenges,
    learnings: $learnings,
    notes: $notes
  }'
)"

# ------------------------------------------------------------------------------
# Add daily log to progress.json
# ------------------------------------------------------------------------------

tmpfile="$(mktemp)"
jq --argjson newLog "$NEW_LOG" '.dailyLogs += [$newLog]' "$PROGRESS_FILE" > "$tmpfile"
mv "$tmpfile" "$PROGRESS_FILE"

# ------------------------------------------------------------------------------
# Update weekly progress for the current week
#   - Recalculate hours from all logs for that week
#   - Recalculate unique tasks for that week
#   - Update status if needed
# ------------------------------------------------------------------------------

tmpfile="$(mktemp)"
jq --arg week "$CURRENT_WEEK" '
  .weeklyProgress[$week].hoursSpent =
    (.dailyLogs
     | map(select(.week == $week) | .hoursSpent)
     | add // 0)
  |
  .weeklyProgress[$week].tasksCompleted =
    (.dailyLogs
     | map(select(.week == $week) | .tasksCompleted[])
     | unique)
  |
  if .weeklyProgress[$week].status == "not-started" then
    .weeklyProgress[$week].status = "in-progress"
  else
    .
  end
' "$PROGRESS_FILE" > "$tmpfile"
mv "$tmpfile" "$PROGRESS_FILE"

# ------------------------------------------------------------------------------
# Update badges: weeklyStreak (last 7 days) and issuesResolved (sum of challenges)
# ------------------------------------------------------------------------------

SEVEN_DAYS_AGO="$(date -d "-7 days" +%F)"

tmpfile="$(mktemp)"
jq --arg seven "$SEVEN_DAYS_AGO" '
  .badges.weeklyStreak =
    (.dailyLogs
     | map(select(.date >= $seven))
     | length)
  |
  .badges.issuesResolved =
    (.dailyLogs
     | map(.challenges | length)
     | add // 0)
' "$PROGRESS_FILE" > "$tmpfile"
mv "$tmpfile" "$PROGRESS_FILE"

# ------------------------------------------------------------------------------
# Final output
# ------------------------------------------------------------------------------

WEEK_HOURS="$(jq -r --arg week "$CURRENT_WEEK" '.weeklyProgress[$week].hoursSpent' "$PROGRESS_FILE")"
WEEKLY_STREAK="$(jq -r '.badges.weeklyStreak' "$PROGRESS_FILE")"

echo
echo "✨ Progress updated successfully!"
echo "📊 Total hours this week ($CURRENT_WEEK): $WEEK_HOURS"
echo "🔥 Weekly streak: $WEEKLY_STREAK days"
echo
echo "💡 Don't forget to commit your changes:"
echo "   git add progress.json"
echo "   git commit -m \"Daily update: $TODAY\""
