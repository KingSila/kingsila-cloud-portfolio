<#!
.SYNOPSIS
    Stand up a Terraform environment (dev or test) with optional plan and summary.
.DESCRIPTION
    Initializes (if needed), creates a plan (optional), applies infrastructure, and prints key outputs.
.PARAMETER Environment
    The target environment folder under infra/environments (dev | test). Defaults to 'dev'.
.PARAMETER PlanFirst
    If specified, runs `terraform plan -out` before apply.
.PARAMETER SkipInit
    Skip terraform init step (assumes already initialized).
.PARAMETER SummaryFile
    Path to append a short summary (e.g. TRACKER.md). If omitted, just writes to console.
.EXAMPLE
    pwsh ./start-environment.ps1 -Environment dev -PlanFirst -SummaryFile TRACKER.md
#>
param(
    [ValidateSet('dev','test')]
    [string]$Environment = 'dev',
    [switch]$PlanFirst,
    [switch]$SkipInit,
    [string]$SummaryFile
)

$ErrorActionPreference = 'Stop'

function Write-Header($Text) {
    Write-Host "`n=== $Text ===" -ForegroundColor Cyan
}

function Import-ExistingResourceGroupIfNeeded {
    param(
        [string]$ResourceGroupName
    )
    Write-Header "Resource Group Check"
    # If RG exists in Azure but not in Terraform state, import it so apply doesn't fail.
    $stateList = terraform state list 2>$null
    $inState = $stateList -match '^azurerm_resource_group\.rg$'
    if ($inState) {
    Write-Host "RG already in terraform state." -ForegroundColor DarkGreen
        return
    }
    # Check if RG exists remotely
    $rg = az group show -n $ResourceGroupName 2>$null | ConvertFrom-Json
    if ($rg) {
    Write-Host "RG exists in Azure but not in state. Importing..." -ForegroundColor Yellow
        $importId = $rg.id
    terraform import azurerm_resource_group.rg $importId | Write-Host
    } else {
        Write-Host "RG does not exist; Terraform will create it." -ForegroundColor Yellow
    }
}

$envPath = Join-Path -Path $PSScriptRoot -ChildPath "infra/environments/$Environment"
if (!(Test-Path $envPath)) { throw "Environment path not found: $envPath" }

Push-Location $envPath
try {
    Write-Header "Environment: $Environment"

    if (-not $SkipInit) {
        if (-not (Test-Path (Join-Path $envPath '.terraform'))) {
            Write-Header 'Terraform Init'
            terraform init | Write-Host
        } else {
            Write-Host 'Terraform already initialized. Use -SkipInit to force skip.'
        }
    }

    if ($PlanFirst) {
        Write-Header 'Terraform Plan'
        terraform plan -var-file='terraform.tfvars' -out="$Environment.plan" | Write-Host
        Write-Header 'Terraform Apply (from plan)'
        terraform apply -auto-approve "$Environment.plan" | Write-Host
    } else {
        # Attempt RG import prior to direct apply to avoid existing RG conflicts
    Import-ExistingResourceGroupIfNeeded -ResourceGroupName $env:TF_VAR_resource_group_name
        Write-Header 'Terraform Apply (direct)'
        terraform apply -auto-approve -var-file='terraform.tfvars' | Write-Host
    }

    Write-Header 'Outputs'
    $outputsRaw = terraform output -json
    $outputs = $outputsRaw | ConvertFrom-Json

    $summaryLines = @()
    $summaryLines += "`n### Environment Started: $Environment ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))"
    foreach ($key in $outputs.PSObject.Properties.Name) {
        $val = $outputs.$key.value
        # Use $() to avoid lint false positive on colon after variable
        $summaryLines += "- $($key): $($val)"
    }

    if ($SummaryFile) {
        $target = Join-Path $PSScriptRoot $SummaryFile
        Add-Content -Path $target -Value $summaryLines
        Write-Host "Summary appended to $SummaryFile" -ForegroundColor Green
    } else {
        Write-Host ($summaryLines -join "`n")
    }
}
finally {
    Pop-Location
}
