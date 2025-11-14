# CI/CD Pipeline Documentation

## Overview

This repository uses GitHub Actions for continuous integration and deployment of Terraform infrastructure to Azure.

## Pipeline Architecture

```
┌─────────────────┐
│   Pull Request  │
└────────┬────────┘
         │
         ▼
┌────────────────────────────────────────┐
│  terraform-plan (dev, test)            │
│  - Format check                        │
│  - Init & validate                     │
│  - Plan infrastructure changes         │
│  - Comment plan on PR                  │
└────────┬───────────────────────────────┘
         │
         │ (PR merged to main)
         ▼
┌────────────────────────────────────────┐
│  terraform-apply-dev                   │
│  - Deploy to dev environment           │
│  - Requires environment approval (opt) │
└────────┬───────────────────────────────┘
         │
         │ (sequential)
         ▼
┌────────────────────────────────────────┐
│  terraform-apply-test                  │
│  - Deploy to test environment          │
│  - Requires environment approval       │
└────────────────────────────────────────┘
```

## Workflows

### 1. Terraform CI/CD (`terraform-ci.yml`)

**Triggers:**
- Pull requests to `main` branch
- Pushes to `main` branch
- Manual dispatch with environment selection

**Jobs:**

#### `terraform-plan`
- Runs on: Pull requests and pushes
- Environments: dev, test (parallel)
- Steps:
  1. Format check (`terraform fmt`)
  2. Initialize Terraform
  3. Validate configuration
  4. Generate plan
  5. Upload plan as artifact
  6. Comment plan on PR (if applicable)

#### `terraform-apply-dev`
- Runs on: Push to main (after plan succeeds)
- Environment: dev
- Steps:
  1. Download plan from artifacts
  2. Apply plan automatically
  3. Save outputs

#### `terraform-apply-test`
- Runs on: Push to main (after dev succeeds)
- Environment: test
- Requires: dev deployment to complete first
- Steps:
  1. Download plan from artifacts
  2. Apply plan automatically
  3. Save outputs

### 2. Terraform Destroy (`terraform-destroy.yml`)

**Triggers:**
- Manual dispatch only

**Inputs:**
- `environment`: dev or test
- `confirm`: Must type "destroy" to proceed

**Safety Features:**
- Confirmation required
- Shows destroy plan before executing
- Requires environment approval
- Creates summary of destruction

### 3. Terraform Drift Detection (`terraform-drift-detection.yml`)

**Triggers:**
- Daily at 9 AM UTC (scheduled)
- Manual dispatch

**Purpose:**
Detects configuration drift by comparing current infrastructure state with Terraform configuration.

**Actions:**
- Runs `terraform plan` without applying
- If changes detected:
  - Creates GitHub issue
  - Labels with `drift`, `infrastructure`, `{environment}`
  - Includes full drift details

## Required Secrets

Configure these secrets in GitHub repository settings:

| Secret | Description |
|--------|-------------|
| `ARM_CLIENT_ID` | Azure Service Principal Application ID |
| `ARM_CLIENT_SECRET` | Azure Service Principal Secret |
| `ARM_SUBSCRIPTION_ID` | Azure Subscription ID |
| `ARM_TENANT_ID` | Azure AD Tenant ID |

## GitHub Environments

### Setup Instructions

1. Navigate to: **Settings → Environments**
2. Create environments:
   - `dev` (optional approval)
   - `dev-destroy` (requires approval)
   - `test` (requires approval)
   - `test-destroy` (requires approval)

### Recommended Environment Protection Rules

#### Dev Environment
- ✅ Required reviewers: 0 (auto-deploy)
- ✅ Wait timer: 0 minutes
- ❌ Deployment branches: main only

#### Dev-Destroy Environment
- ✅ Required reviewers: 1
- ✅ Wait timer: 0 minutes
- ✅ Deployment branches: main only

#### Test Environment
- ✅ Required reviewers: 1
- ✅ Wait timer: 0 minutes
- ✅ Deployment branches: main only

#### Test-Destroy Environment
- ✅ Required reviewers: 2
- ✅ Wait timer: 5 minutes
- ✅ Deployment branches: main only

## Usage

### Deploy Infrastructure

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/add-storage-account
   ```

2. **Make infrastructure changes:**
   ```bash
   cd infra/environments/dev
   # Edit your .tf files
   ```

3. **Commit and push:**
   ```bash
   git add .
   git commit -m "feat: add storage account for backups"
   git push origin feature/add-storage-account
   ```

4. **Create Pull Request:**
   - GitHub Actions will automatically run `terraform plan`
   - Review the plan in PR comments
   - Check for format, validation, and plan status

5. **Merge PR:**
   - After approval, merge to main
   - GitHub Actions will automatically:
     - Deploy to dev environment
     - Deploy to test environment (with approval)

### Destroy Infrastructure

1. **Navigate to Actions tab**
2. **Select "Terraform Destroy" workflow**
3. **Click "Run workflow"**
4. **Select environment** (dev or test)
5. **Type "destroy" in confirmation**
6. **Click "Run workflow"**
7. **Approve in environment** (if required)

### Check for Drift

1. **Navigate to Actions tab**
2. **Select "Terraform Drift Detection" workflow**
3. **Click "Run workflow"**
4. **Check workflow summary** for drift status
5. **Review issues** if drift detected

## Best Practices

### 1. Always Use Pull Requests
- Never push directly to main
- Let CI/CD validate changes before merge
- Review Terraform plans in PR comments

### 2. Review Plans Carefully
- Check resource additions/changes/deletions
- Verify no unexpected changes
- Look for configuration drift warnings

### 3. Use Feature Branches
```bash
# Feature branches
feature/add-storage
feature/update-nsg-rules
feature/add-monitoring

# Bugfix branches
fix/route-table-association
fix/app-service-subnet

# Infrastructure branches
infra/migrate-to-new-region
infra/upgrade-terraform-version
```

### 4. Semantic Commit Messages
```bash
feat: add new storage account for logs
fix: correct NSG rule for SSH access
docs: update README with new architecture
chore: upgrade Terraform to 1.6.0
refactor: reorganize module structure
```

### 5. Environment Progression
- **Dev**: Test new features, rapid iteration
- **Test**: Staging for production, full testing
- **Prod**: Production (coming soon)

Always promote changes: dev → test → prod

### 6. Drift Detection
- Review drift issues promptly
- Investigate manual changes
- Update Terraform or revert changes
- Never make manual changes in Azure Portal for managed resources

## Troubleshooting

### Plan Fails on PR
1. Check format: `terraform fmt -check`
2. Validate locally: `terraform validate`
3. Check secrets configuration
4. Review error in workflow logs

### Apply Fails
1. Check if plan artifact exists
2. Verify Azure credentials
3. Check resource quotas
4. Review detailed error logs

### Drift Detected
1. Review the drift issue
2. Compare with recent changes
3. Options:
   - Update Terraform code
   - Run apply to revert manual changes
   - Document intentional drift

## Monitoring

### Workflow Status
- Check Actions tab for workflow runs
- Review step-by-step logs
- Download artifacts for detailed plans

### Azure Resources
- Monitor via Azure Portal
- Check Application Insights
- Review Log Analytics workspace

## Future Enhancements

- [ ] Add production environment
- [ ] Implement blue-green deployments
- [ ] Add automated testing (terratest)
- [ ] Integrate cost estimation
- [ ] Add security scanning (checkov/tfsec)
- [ ] Implement GitOps with ArgoCD
- [ ] Add Slack/Teams notifications

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
