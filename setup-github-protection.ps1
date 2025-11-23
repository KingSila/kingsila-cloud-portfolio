#!/usr/bin/env pwsh

param(
    [switch]$AutoProtect,
    [string]$Branch = 'main',
    [string]$Repo = 'KingSila/kingsila-cloud-portfolio',
    [int]$Approvals = 1,
    [string[]]$StatusChecks = @() # e.g. 'Terraform Plan - dev','Terraform Plan - test'
)

<#
.SYNOPSIS
    Quick setup checklist for GitHub branch protection and environments

.DESCRIPTION
    Interactive checklist to guide you through setting up branch protection
    and GitHub environments for the CI/CD pipeline
#>

Write-Host @"
╔════════════════════════════════════════════════════════════════════╗
║         GitHub Branch Protection & Environment Setup              ║
╚════════════════════════════════════════════════════════════════════╝

This script will guide you through setting up:
  ✓ Branch protection rules for main branch
  ✓ GitHub environments (dev, test, destroy)
  ✓ Environment protection rules

"@ -ForegroundColor Cyan

# Get repository info
$repo = $Repo
$repoUrl = "https://github.com/$repo"

if ($AutoProtect) {
    Write-Host "\n⚙️ Applying branch protection automatically for '$Branch'..." -ForegroundColor Cyan
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Host "GitHub CLI (gh) not found. Install from https://cli.github.com and re-run." -ForegroundColor Red
        exit 1
    }
    # Build payload object
    $payload = [ordered]@{
        required_pull_request_reviews = [ordered]@{
            required_approving_review_count = $Approvals
            require_code_owner_reviews     = $false
            require_last_push_approval     = $false
            dismiss_stale_reviews          = $true
        }
        enforce_admins                 = $true
        required_status_checks         = [ordered]@{
            strict   = $true
            contexts = $StatusChecks
        }
        restrictions                   = $null
        allow_force_pushes             = $false
        allow_deletions                = $false
        required_linear_history        = $true
        required_conversation_resolution = $true
        block_fork_pr_creations        = $false
        lock_branch                    = $false
    }
    $json = $payload | ConvertTo-Json -Depth 6
    $tmp = New-TemporaryFile
    Set-Content -Path $tmp -Value $json -Encoding UTF8
    try {
        gh api -X PUT "repos/$repo/branches/$Branch/protection" -H "Accept: application/vnd.github+json" --input $tmp --silent
        Write-Host "✅ Branch protection applied for '$Branch'." -ForegroundColor Green
        if ($StatusChecks.Count -eq 0) {
            Write-Host "ℹ️ No status checks specified; add them manually later after workflows run." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "❌ Failed to apply protection: $($_.Exception.Message)" -ForegroundColor Red
    }
    finally {
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "`n📋 CHECKLIST`n" -ForegroundColor Yellow

# Branch Protection
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "`n1. BRANCH PROTECTION RULES" -ForegroundColor Green
Write-Host "   Navigate to: $repoUrl/settings/branches" -ForegroundColor White
Write-Host ""
Write-Host "   ✓ Click 'Add branch protection rule'" -ForegroundColor White
Write-Host "   ✓ Branch name pattern: main" -ForegroundColor White
Write-Host "   ✓ Enable: Require a pull request before merging" -ForegroundColor White
Write-Host "   ✓ Enable: Require approvals (1)" -ForegroundColor White
Write-Host "   ✓ Enable: Require status checks to pass" -ForegroundColor White
Write-Host "     - Add: 'Terraform Plan - dev'" -ForegroundColor White
Write-Host "     - Add: 'Terraform Plan - test'" -ForegroundColor White
Write-Host "   ✓ Enable: Require conversation resolution" -ForegroundColor White
Write-Host "   ✓ Enable: Require linear history" -ForegroundColor White
Write-Host "   ✓ Enable: Include administrators" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter when branch protection is configured (skip if AutoProtect used)"

# Environments
Write-Host "`n═══════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "`n2. GITHUB ENVIRONMENTS" -ForegroundColor Green
Write-Host "   Navigate to: $repoUrl/settings/environments" -ForegroundColor White
Write-Host ""

# Dev environment
Write-Host "   📦 Environment: dev" -ForegroundColor Cyan
Write-Host "      ✓ Click 'New environment'" -ForegroundColor White
Write-Host "      ✓ Name: dev" -ForegroundColor White
Write-Host "      ✓ Required reviewers: 0 (auto-deploy)" -ForegroundColor White
Write-Host "      ✓ Deployment branches: main only" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter when 'dev' environment is configured"

# Dev-destroy environment
Write-Host "`n   📦 Environment: dev-destroy" -ForegroundColor Cyan
Write-Host "      ✓ Click 'New environment'" -ForegroundColor White
Write-Host "      ✓ Name: dev-destroy" -ForegroundColor White
Write-Host "      ✓ Required reviewers: 1" -ForegroundColor White
Write-Host "      ✓ Deployment branches: main only" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter when 'dev-destroy' environment is configured"

# Test environment
Write-Host "`n   📦 Environment: test" -ForegroundColor Cyan
Write-Host "      ✓ Click 'New environment'" -ForegroundColor White
Write-Host "      ✓ Name: test" -ForegroundColor White
Write-Host "      ✓ Required reviewers: 1" -ForegroundColor White
Write-Host "      ✓ Wait timer: 5 minutes" -ForegroundColor White
Write-Host "      ✓ Deployment branches: main only" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter when 'test' environment is configured"

# Test-destroy environment
Write-Host "`n   📦 Environment: test-destroy" -ForegroundColor Cyan
Write-Host "      ✓ Click 'New environment'" -ForegroundColor White
Write-Host "      ✓ Name: test-destroy" -ForegroundColor White
Write-Host "      ✓ Required reviewers: 1" -ForegroundColor White
Write-Host "      ✓ Wait timer: 5 minutes" -ForegroundColor White
Write-Host "      ✓ Deployment branches: main only" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter when 'test-destroy' environment is configured"

# Verification
Write-Host "`n═══════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "`n3. VERIFICATION" -ForegroundColor Green
Write-Host ""
Write-Host "   Let's test the setup!" -ForegroundColor White
Write-Host ""
Write-Host "   Run these commands:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   git checkout -b feature/test-branch-protection" -ForegroundColor White
Write-Host "   echo '## Test' >> README.md" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor White
Write-Host "   git commit -m 'test: verify branch protection'" -ForegroundColor White
Write-Host "   git push origin feature/test-branch-protection" -ForegroundColor White
Write-Host ""
Write-Host "   Then create a PR on GitHub and verify:" -ForegroundColor Yellow
Write-Host "   ✓ Terraform Plan runs automatically" -ForegroundColor White
Write-Host "   ✓ Plan output appears as PR comment" -ForegroundColor White
Write-Host "   ✓ Status checks show in PR" -ForegroundColor White
Write-Host "   ✓ Cannot merge until checks pass" -ForegroundColor White
Write-Host ""

$runTest = Read-Host "Would you like to run the test now? (y/n)"

if ($runTest -eq "y") {
    Write-Host "`n🚀 Creating test branch..." -ForegroundColor Cyan

    git checkout -b feature/test-branch-protection

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Branch created" -ForegroundColor Green

        # Add a comment to README
        Add-Content -Path "README.md" -Value "`n## Branch Protection Test`n"

        git add .
        git commit -m "test: verify branch protection and CI/CD pipeline"
        git push origin feature/test-branch-protection

        if ($LASTEXITCODE -eq 0) {
            Write-Host "`n✅ Test branch pushed successfully!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Next steps:" -ForegroundColor Yellow
            Write-Host "1. Go to: $repoUrl/pulls" -ForegroundColor White
            Write-Host "2. Create a Pull Request" -ForegroundColor White
            Write-Host "3. Watch the CI/CD pipeline run" -ForegroundColor White
            Write-Host "4. Review the Terraform plan in PR comments" -ForegroundColor White
            Write-Host ""
        }
    }
} else {
    Write-Host "`nSetup complete! Test manually when ready." -ForegroundColor Green
}

Write-Host "`n═══════════════════════════════════════════════════════════════" -ForegroundColor Gray
Write-Host "`n✨ Setup Complete!" -ForegroundColor Green
Write-Host "`nDocumentation:" -ForegroundColor Yellow
Write-Host "  - Branch Protection: docs/github-setup.md" -ForegroundColor White
Write-Host "  - CI/CD Pipeline: docs/cicd.md" -ForegroundColor White
Write-Host "  - Workflow README: .github/workflows/README.md" -ForegroundColor White
Write-Host ""
