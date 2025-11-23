# GitHub Actions CI/CD Workflows

This directory contains GitHub Actions workflows for automated Terraform deployment and infrastructure management.

## 🚀 Workflows

### 1. `terraform-ci.yml` - Main CI/CD Pipeline

Automated Terraform validation, planning, and deployment pipeline.

**Triggers:**
- Pull Requests to `main` (validation and plan)
- Push to `main` (plan + apply)
- Manual workflow dispatch with environment selection

**Features:**
- ✅ Format checking (`terraform fmt`)
- ✅ Validation (`terraform validate`)
- ✅ Plan generation with artifacts
- ✅ PR comments with formatted plan output
- ✅ Sequential deployment (dev → test)
- ✅ Environment protection with approvals
- ✅ Plan artifact preservation and reuse

**Environments:**
- `dev` - Auto-deploys on merge to main
- `test` - Deploys after dev, requires approval

### 2. `terraform-destroy.yml` - Controlled Destruction

Manual workflow for safely destroying infrastructure.

**Triggers:**
- Manual dispatch only

**Safety Features:**
- ✅ Requires environment selection
- ✅ Confirmation input ("destroy" to proceed)
- ✅ Shows destroy plan before execution
- ✅ Environment approval required
- ✅ Detailed destruction summary

**Use Case:**
- End-of-day teardown to save costs
- Environment cleanup
- Resource decommissioning

### 3. `terraform-drift-detection.yml` - Configuration Monitoring

Automated detection of infrastructure drift.

**Triggers:**
- Daily at 9 AM UTC (cron schedule)
- Manual dispatch

**Features:**
- ✅ Compares actual state vs. Terraform config
- ✅ Creates GitHub issues for detected drift
- ✅ Includes full drift details
- ✅ Labels for easy tracking
- ✅ Workflow summary with status

**Use Case:**
- Detect manual changes in Azure Portal
- Compliance monitoring
- Configuration audit trail

---

## 🔐 Required GitHub Secrets

To use this workflow, configure the following secrets in your GitHub repository:

**Settings → Secrets and variables → Actions → New repository secret**

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `ARM_CLIENT_ID` | Service Principal Application ID | From Azure Portal or `terraform-sp` |
| `ARM_CLIENT_SECRET` | Service Principal Password | Created during SP setup |
| `ARM_SUBSCRIPTION_ID` | Azure Subscription ID | `az account show --query id -o tsv` |
| `ARM_TENANT_ID` | Azure AD Tenant ID | `az account show --query tenantId -o tsv` |

### Getting Service Principal Credentials

If you need to retrieve your existing service principal details:

```powershell
# Get Subscription ID
az account show --query id -o tsv

# Get Tenant ID
az account show --query tenantId -o tsv

# List service principals (find terraform-sp)
az ad sp list --display-name terraform-sp --query "[].appId" -o tsv
```

**Note:** The client secret can't be retrieved after creation. If lost, create a new one:

```powershell
az ad sp credential reset --name terraform-sp --query password -o tsv
```

---

## 🎯 Environment Configuration

### Dev Environment
- Automatically deploys on push to `main`
- No approval required (for rapid iteration)

### Test Environment
- Plans run on all PRs
- Manual deployment via workflow_dispatch
- Can add approval gates in repository settings

### Prod Environment (Future)
- Requires manual approval
- Protected environment with reviewers
- Add to matrix when ready

---

## 📋 Usage

### Automatic (Recommended)
1. Create a feature branch
2. Make infrastructure changes
3. Open PR → workflow runs `terraform plan`
4. Review plan output in PR comments
5. Merge PR → workflow runs `terraform apply` on dev

### Manual Trigger
1. Go to **Actions** tab in GitHub
2. Select **Terraform CI/CD** workflow
3. Click **Run workflow**
4. Select branch and environment

---

## 🔧 Customization

### Add Test Environment Auto-Deploy
Update the apply job matrix:
```yaml
strategy:
  matrix:
    environment: [dev, test]
```

### Add Approval Gates
1. Go to **Settings → Environments**
2. Click **New environment** or edit existing
3. Add **Required reviewers**
4. Configure **Wait timer** if needed

### Run on Specific Paths Only
Already configured to trigger only on:
- `infra/**` changes
- Workflow file changes

---

## 📊 Artifacts

The workflow uploads:
- **Plan outputs** - Retained for 5 days
- **Apply outputs** - Retained for 30 days

Access via **Actions → Workflow run → Artifacts**

---

## 🛡️ Security Best Practices

✅ Secrets stored in GitHub (never in code)
✅ Service principal with least privilege
✅ State file in Azure Storage (not in repo)
✅ Pull request reviews before apply
✅ Branch protection on main recommended

---

## 📖 Next Steps

1. Add GitHub secrets (see table above)
2. Enable branch protection for `main`
3. Test workflow with a sample PR
4. Add environment approvals for test/prod
5. Consider adding drift detection job
