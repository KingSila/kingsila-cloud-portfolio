# Quick Daily Update Script
# Usage: .\quick-update.ps1 -Hours 3 -Tasks "Task 1","Task 2" -Week 1

param(
    [Parameter(Mandatory=$true)]
    [int]$Hours,
    
    [Parameter(Mandatory=$true)]
    [string[]]$Tasks,
    
    [Parameter(Mandatory=$true)]
    [int]$Week,
    
    [string]$Notes = ""
)

$progressFile = "progress.json"
$today = Get-Date -Format "yyyy-MM-dd"

$weekMap = @{
    1 = "week1-2"
    2 = "week3-4"
    3 = "week5-6"
    4 = "week7-8"
    5 = "week9-10"
    6 = "week11-12"
}
$currentWeek = $weekMap[$Week]

# Read and update progress
$progress = Get-Content $progressFile | ConvertFrom-Json

# Remove existing entry for today if it exists
$progress.dailyLogs = $progress.dailyLogs | Where-Object { $_.date -ne $today }

# Create new entry
$dailyLog = @{
    date = $today
    week = $currentWeek
    hoursSpent = $Hours
    tasksCompleted = $Tasks
    challenges = @()
    learnings = @()
    notes = $Notes
}

$progress.dailyLogs += $dailyLog

# Update weekly progress
$weekData = $progress.weeklyProgress.$currentWeek
$weekData.hoursSpent += $Hours
foreach ($task in $Tasks) {
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

# Save
$progress | ConvertTo-Json -Depth 10 | Set-Content $progressFile

Write-Host "✅ Quick update saved for $today" -ForegroundColor Green
Write-Host "⏱️  Hours: $Hours | 📋 Tasks: $($Tasks.Count)" -ForegroundColor Cyan
