# Daily Progress Update Script
# Usage: .\update-progress.ps1

$progressFile = "progress.json"
$today = Get-Date -Format "yyyy-MM-dd"

# Read existing progress
$progress = Get-Content $progressFile | ConvertFrom-Json

# Check if today's entry already exists
$existingEntry = $progress.dailyLogs | Where-Object { $_.date -eq $today }

if ($existingEntry) {
    Write-Host "⚠️  Entry for $today already exists. Would you like to update it? (y/n)" -ForegroundColor Yellow
    $update = Read-Host
    if ($update -ne 'y') {
        Write-Host "❌ Update cancelled." -ForegroundColor Red
        exit
    }
    # Remove existing entry
    $progress.dailyLogs = $progress.dailyLogs | Where-Object { $_.date -ne $today }
}

# Prompt for daily information
Write-Host "`n📅 Daily Progress Update - $today" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

# Current week
Write-Host "`n📌 Which week are you working on?" -ForegroundColor Green
Write-Host "   1. week1-2: Azure Core + Governance"
Write-Host "   2. week3-4: Terraform Advanced"
Write-Host "   3. week5-6: CI/CD & Automation"
Write-Host "   4. week7-8: Security & Monitoring"
Write-Host "   5. week9-10: Containers & Modern Infra"
Write-Host "   6. week11-12: Portfolio & Interview Readiness"
$weekChoice = Read-Host "Enter number (1-6)"

$weekMap = @{
    "1" = "week1-2"
    "2" = "week3-4"
    "3" = "week5-6"
    "4" = "week7-8"
    "5" = "week9-10"
    "6" = "week11-12"
}
$currentWeek = $weekMap[$weekChoice]

# Hours spent
$hoursSpent = Read-Host "`n⏱️  Hours spent today"

# Tasks completed
Write-Host "`n✅ Tasks completed today (one per line, press Enter twice when done):" -ForegroundColor Green
$tasks = @()
do {
    $task = Read-Host "  -"
    if ($task) { $tasks += $task }
} while ($task)

# Challenges
Write-Host "`n🚧 Challenges faced (one per line, press Enter twice when done):" -ForegroundColor Yellow
$challenges = @()
do {
    $challenge = Read-Host "  -"
    if ($challenge) { $challenges += $challenge }
} while ($challenge)

# Learnings
Write-Host "`n🧠 Key learnings (one per line, press Enter twice when done):" -ForegroundColor Magenta
$learnings = @()
do {
    $learning = Read-Host "  -"
    if ($learning) { $learnings += $learning }
} while ($learning)

# Notes
$notes = Read-Host "`n📝 Additional notes"

# Create new daily log entry
$dailyLog = @{
    date = $today
    week = $currentWeek
    hoursSpent = [int]$hoursSpent
    tasksCompleted = $tasks
    challenges = $challenges
    learnings = $learnings
    notes = $notes
}

# Add to daily logs
$progress.dailyLogs += $dailyLog

# Update weekly progress
$weekData = $progress.weeklyProgress.$currentWeek
$weekData.hoursSpent += [int]$hoursSpent
foreach ($task in $tasks) {
    if ($weekData.tasksCompleted -notcontains $task) {
        $weekData.tasksCompleted += $task
    }
}
if ($weekData.status -eq "not-started") {
    $weekData.status = "in-progress"
}

# Update badges
$progress.badges.weeklyStreak = ($progress.dailyLogs |
    Where-Object { [datetime]$_.date -ge (Get-Date).AddDays(-7) }).Count

$progress.badges.issuesResolved = ($progress.dailyLogs |
    ForEach-Object { $_.challenges.Count } |
    Measure-Object -Sum).Sum

# Save updated progress
$progress | ConvertTo-Json -Depth 10 | Set-Content $progressFile

Write-Host "`n✨ Progress updated successfully!" -ForegroundColor Green
Write-Host "📊 Total hours this week: $($weekData.hoursSpent)" -ForegroundColor Cyan
Write-Host "🔥 Weekly streak: $($progress.badges.weeklyStreak) days" -ForegroundColor Cyan
Write-Host "`n💡 Don't forget to commit your changes:`n   git add progress.json`n   git commit -m `"Daily update: $today`"`n" -ForegroundColor Yellow
