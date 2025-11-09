# 🗓️ Daily Notes – Saturday, 9 November 2025

## 🎯 Focus Area
Azure App Service · Terraform VNet Integration · Module Best Practices

## ✅ Tasks Completed
- Added Azure App Service infrastructure to dev environment.
- Created dedicated subnet (snet-appsvc) with Microsoft.Web delegation for App Service.
- Implemented VNet integration for secure App Service connectivity.
- Added Log Analytics Workspace and Application Insights for monitoring.
- Created App Service Plan (Linux, B1 SKU) and Linux Web App (.NET 8.0).
- Added comprehensive outputs for web app URL and monitoring resources.
- Removed duplicate `infra/variables.tf` - consolidated to environment-level variables.
- Cleaned up `.gitignore` to remove duplicate patterns and add module lock file exclusions.
- Fixed Git push issues: removed large Terraform provider binaries (227 MB files).
- Updated `.gitignore` to exclude `.terraform/` directories, `.tfvars` files, and `.env` files.
- Resolved GitHub push protection by removing exposed Azure credentials from `.env` file.
- Created comprehensive README.md for dev environment with deployment instructions.
- **Created test environment** by replicating dev structure.
- Updated test environment with unique names and address spaces (10.20.0.0/16).
- Modified backend state key to `test.terraform.tfstate` for isolation.
- Successfully initialized and validated test environment with `terraform plan`.
- Removed `notes/` from `.gitignore` to track daily logs in version control.
- Updated TRACKER.md to reflect actual progress (Week 1-2 completed).
- Updated progress.json with completed tasks and skill improvements.

## 🕵️‍♂️ To Investigate Further
- Learned about Terraform variable defaults: optional vs required variables.
- Understood module best practices: modules should NOT have provider/terraform blocks.
- Discovered VNet integration can be done via `virtual_network_subnet_id` property (simpler).
- Learned about `.terraform.lock.hcl` placement: environments YES, modules NO.

## 🧩 Issues & Fixes
| Issue | Root Cause | Resolution |
|--------|-------------|-------------|
| Git push failed with HTTP 408 | Large Terraform provider binaries (227 MB) committed | Removed `.terraform/` directories, updated `.gitignore` |
| GitHub push protection blocked | Azure credentials in `.env` file | Removed `.env` from Git, added to `.gitignore` |
| Duplicate VNet integration error | Both `virtual_network_subnet_id` and explicit resource | Removed duplicate `azurerm_app_service_virtual_network_swift_connection` |
| `.terraform.lock.hcl` in modules | Lock files shouldn't be in reusable modules | Added `infra/modules/**/.terraform.lock.hcl` to `.gitignore` |
| Duplicate `.gitignore` patterns | Multiple Terraform sections, redundant patterns | Consolidated and removed duplicates (*.auto.tfvars covered by *.tfvars) |

## 🚀 Next Steps
- Test GitHub Actions workflow with a sample PR.
- Add GitHub secrets for Azure service principal authentication.
- Deploy test environment using terraform apply.
- Add environment protection rules for test/prod in GitHub.
- Implement RBAC and Management Groups configuration.
- Integrate Azure Key Vault for secrets management.
- Add drift detection and automated testing (checkov/terratest).

## 🧠 Learnings
- **Git and Large Files**: Never commit `.terraform/` directories - they contain large provider binaries that exceed GitHub limits.
- **Security Best Practices**: Always exclude `.env`, `*.tfvars`, and state files from version control.
- **Module Organization**: Modules declare variables but don't set provider versions - environments control provider versions.
- **Variable Defaults**: Use `default` to make variables optional; omit for required inputs.
- **VNet Integration**: App Service VNet integration requires subnet delegation to `Microsoft.Web/serverFarms`.
- **Lock File Strategy**: Keep `.terraform.lock.hcl` in environments for reproducibility, exclude from modules for flexibility.
- **Monitoring Stack**: Log Analytics Workspace + Application Insights provides complete observability for App Services.
- **Resource Naming**: Use locals and random integers for unique resource names to avoid conflicts.
- **Multi-Environment Strategy**: Use separate address spaces per environment (dev: 10.10.x.x, test: 10.20.x.x, prod: 10.30.x.x).
- **Environment Isolation**: Each environment has its own backend state file (dev.tfstate, test.tfstate) for safety.
- **Progress Tracking**: JSON format enables PowerShell automation for daily progress updates and reporting.
- **GitHub Actions**: Matrix strategy allows parallel plan execution across multiple environments.
- **CI/CD Security**: Store Azure credentials in GitHub secrets, never in workflow files.
- **Workflow Artifacts**: Upload plan outputs for review and apply outputs for audit trails.

---
