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
- Verify VNet integration in Azure Portal (Web App → Networking).
- Test App Service deployment with sample application.
- Set up CI/CD pipeline for automated deployments.
- Implement test and prod environments with same pattern.
- Add NSG rules for App Service subnet if needed.
- Consider adding Azure Bastion or NAT Gateway based on requirements.

## 🧠 Learnings
- **Git and Large Files**: Never commit `.terraform/` directories - they contain large provider binaries that exceed GitHub limits.
- **Security Best Practices**: Always exclude `.env`, `*.tfvars`, and state files from version control.
- **Module Organization**: Modules declare variables but don't set provider versions - environments control provider versions.
- **Variable Defaults**: Use `default` to make variables optional; omit for required inputs.
- **VNet Integration**: App Service VNet integration requires subnet delegation to `Microsoft.Web/serverFarms`.
- **Lock File Strategy**: Keep `.terraform.lock.hcl` in environments for reproducibility, exclude from modules for flexibility.
- **Monitoring Stack**: Log Analytics Workspace + Application Insights provides complete observability for App Services.
- **Resource Naming**: Use locals and random integers for unique resource names to avoid conflicts.

---
