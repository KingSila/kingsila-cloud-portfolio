<#!
.SYNOPSIS
    Tear down a Terraform environment (dev or test) with optional plan and summary logging.
.DESCRIPTION
    Destroys resources for the chosen environment, capturing a summary of what was removed.
.PARAMETER Environment
    Target environment folder name under infra/environments (dev | test).
.PARAMETER PlanFirst
    Run a destroy plan and save it before applying.
.PARAMETER SummaryFile
    Path to append a destruction summary (e.g. TRACKER.md).
.EXAMPLE
    pwsh ./destroy-environment.ps1 -Environment dev -PlanFirst -SummaryFile TRACKER.md
#>
param(
    [ValidateSet('dev','test')]
    [string]$Environment = 'dev',
    [switch]$PlanFirst,
    [string]$SummaryFile
)

$ErrorActionPreference = 'Stop'

function Write-Header($Text) { Write-Host "`n=== $Text ===" -ForegroundColor Magenta }

$envPath = Join-Path -Path $PSScriptRoot -ChildPath "infra/environments/$Environment"
if (!(Test-Path $envPath)) { throw "Environment path not found: $envPath" }

Push-Location $envPath
try {
    Write-Header "Destroy Environment: $Environment"

    if (-not (Test-Path (Join-Path $envPath '.terraform'))) {
        Write-Header 'Terraform Init'
        terraform init | Write-Host
    }

    if ($PlanFirst) {
        Write-Header 'Terraform Destroy Plan'
        terraform plan -destroy -var-file='terraform.tfvars' -out="$Environment-destroy.plan" | Write-Host
        Write-Header 'Terraform Destroy (from plan)'
        terraform apply -auto-approve "$Environment-destroy.plan" | Write-Host
    } else {
        Write-Header 'Terraform Destroy (direct)'
        terraform destroy -auto-approve -var-file='terraform.tfvars' | Write-Host
    }

    # Capture previous state summary (after destroy state should be empty of our resources except backend)
    Write-Header 'Post-Destroy State'
    $remaining = terraform state list 2>$null
    if ($remaining) {
        Write-Host "Remaining managed objects (likely backend-related):" -ForegroundColor Yellow
        $remaining | ForEach-Object { Write-Host " - $_" }
    } else {
        Write-Host 'No resources remain in state.' -ForegroundColor Green
    }

    if ($SummaryFile) {
        $lines = @()
        $lines += "`n### Environment Destroyed: $Environment ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))" 
        if ($remaining) {
            $lines += "Remaining state objects:"; $lines += ($remaining | ForEach-Object { "- $_" })
        } else { $lines += "All resources destroyed." }
        Add-Content -Path (Join-Path $PSScriptRoot $SummaryFile) -Value $lines
        Write-Host "Summary appended to $SummaryFile" -ForegroundColor Green
    }
}
finally { Pop-Location }
