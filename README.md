# KingSila Cloud Portfolio – Azure | Terraform | DevOps

Welcome 👋  
This repository documents my hands-on journey from experienced engineer to
**Senior Cloud Engineer (Azure / Terraform / DevOps)** ready for
remote roles in the **US** and **Europe**.

---

## 🚀 Purpose
- Strengthen production-grade Azure infrastructure and DevOps expertise.  
- Build reusable Terraform modules for enterprise-scale deployments.  
- Demonstrate automation and CI/CD design through real projects.  
- Showcase portfolio projects and continuous learning progress.

---

## 📆 Timeline
**November 2025 → January 2026**  
12-week plan focused on:
1. Azure core infrastructure & governance  
2. Terraform advanced modules  
3. CI/CD and automation  
4. Security, monitoring, and cost optimisation  
5. Containers & AKS  
6. Final portfolio project + interview prep  

See [`TRACKER.md`](./TRACKER.md) for week-by-week milestones.

---

## 🧱 Project Structure
```
infra/              → Terraform modules & environments
  ├── modules/      → Reusable infrastructure modules
  ├── environments/ → Dev, test, prod configurations
  └── backend/      → Remote state configuration
.github/
  └── workflows/    → CI/CD pipelines
docs/               → Architecture & technical documentation
  ├── cicd.md       → CI/CD pipeline documentation
  ├── github-setup.md → Branch protection setup guide
  └── ...
notes/              → Daily learning logs
pipelines/          → Additional pipeline configurations
```


---

## 🧰 Tooling
| Area | Tools |
|------|--------|
| Cloud | Azure, Azure CLI, Azure DevOps |
| IaC | Terraform, AzureRM provider, Terraform Cloud |
| Automation | GitHub Actions, YAML pipelines |
| Security | Azure Policy, Defender for Cloud, Key Vault |
| Observability | Azure Monitor, Log Analytics |
| Source Control | Git, GitHub |

---

## 🧩 Featured Portfolio Project
**End-to-End Azure Cloud Infrastructure with Terraform & GitHub Actions**
- Hub-and-Spoke network  
- AKS deployment with Managed Identity  
- Full CI/CD pipeline  
- Security policies, monitoring, cost controls  

---

## 🏁 Current Status

**Week 3-4: CI/CD & Environments** ✅ In Progress

- ✅ Reusable Terraform modules (VNet, NSG, Route Tables)
- ✅ Remote state with Azure Storage backend
- ✅ Dev environment with App Service & monitoring
- ✅ GitHub Actions CI/CD pipeline
- ✅ Branch protection & environment approvals
- ⏳ Testing & validation

---

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and authenticated
- Terraform >= 1.13.0
- GitHub account with repository secrets configured

### Setup CI/CD
```bash
# Run the interactive setup script
./setup-github-protection.ps1
```

Or manually configure:
1. Branch protection rules (see [`docs/github-setup.md`](./docs/github-setup.md))
2. GitHub environments (dev, test, dev-destroy, test-destroy)
3. Repository secrets (ARM_CLIENT_ID, ARM_CLIENT_SECRET, etc.)

### Deploy Infrastructure
```bash
# Feature branch workflow
git checkout -b feature/my-changes
# Make your changes
git commit -am "feat: add new resource"
git push origin feature/my-changes
# Create PR → CI runs → Merge → Auto-deploy
```
### Daily Environment Workflow

Start of day (stand up dev):

```powershell
pwsh ./start-environment.ps1 -Environment dev -PlanFirst -SummaryFile TRACKER.md
```

Fast path (no plan, just apply):

```powershell
pwsh ./start-environment.ps1 -Environment dev
```

VS Code Task alternative:

1. Open command palette → Run Task → `🌅 START OF DAY: Terraform Apply (DEV)`
2. End of day teardown → `🚨 END OF DAY: Terraform Destroy (DEV)`

Test environment (optional):

```powershell
pwsh ./start-environment.ps1 -Environment test -PlanFirst
```

Script flags:

- `-PlanFirst` creates a saved plan before apply.
- `-SkipInit` skips `terraform init` if already initialized.
- `-SummaryFile TRACKER.md` appends outputs summary to tracker.

Destroy end of day (manual alternative to task):

```powershell
terraform destroy -auto-approve -var-file='terraform.tfvars' -chdir=infra/environments/dev
```

Tip: Re-run with `-PlanFirst` weekly to catch drift early.

See [`docs/cicd.md`](./docs/cicd.md) for detailed pipeline documentation.

---

## 🧠 Learning Resources

- Microsoft Learn: [Azure Architect](https://learn.microsoft.com/en-us/training/paths/azure-architecture-design/)
- HashiCorp Learn: [Terraform on Azure](https://developer.hashicorp.com/terraform/tutorials/azure)
- GitHub Docs: [Actions for Terraform](https://docs.github.com/en/actions)
- John Savill’s YouTube: *Azure Masterclass*

## 🔒 Security Practices

This repository follows strict security and privacy guidelines to prevent accidental exposure of sensitive information:

- **No credentials or secrets** are stored in the repository.  
  All secrets (keys, tokens, passwords, IP addresses) are passed securely through environment variables or `.tfvars` files that are excluded from version control.

- **Terraform state files are ignored** (`*.tfstate`, `*.tfstate.*`).  
  State files often contain resource IDs and connection strings — keeping them local prevents leaking internal infrastructure details.

- **Local variable and configuration files** such as `terraform.tfvars`, `.env`, or CLI credentials under `.azure/` are never committed.

- **Example placeholders only** are used for sensitive inputs (e.g., `"YOUR_PUBLIC_IP/32"` instead of real IPs).  
  Always replace these locally before running deployments.

- **GitHub secrets** or secure pipelines (like Azure DevOps variable groups) are used for automated workflows.

- **Security scanning** is encouraged.  
  Use tools like [tfsec](https://aquasecurity.github.io/tfsec/), [Trivy](https://github.com/aquasecurity/trivy), or GitHub’s built-in secret scanning to continuously check the repo.

---

### 🧠 Tip: Keep Your Local Environment Safe

- Store your IPs, credentials, and other private variables in `terraform.tfvars` or environment variables.  
- Never push `.tfvars` or `.env` files — they’re ignored by `.gitignore`.  
- Use `terraform apply -var` flags or environment variables (`TF_VAR_*`) to pass values securely at runtime.

---

Maintaining a clean boundary between public code and private configuration keeps this repository reusable, secure, and audit-friendly.



---

## 🤝 Connect

**LinkedIn:** [linkedin.com/in/silasmokone](https://www.linkedin.com/in/silasmokone/)  
**GitHub:** [github.com/KingSila](https://github.com/KingSila)  

## Branch Protection Test
- now i am tired 
- --- IT CANT BE 

