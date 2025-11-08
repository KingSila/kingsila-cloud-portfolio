# 🗓️ Daily Notes – Friday, 7 November 2025

## 🎯 Focus Area
Azure · Terraform · DevOps Practice

## ✅ Tasks Completed
- Fixed Terraform module duplication errors (`vnet_id`, `subnet_ids`).
- Reviewed PowerShell-based setup for `az login` and ARM environment variables.
- Created new Service Principal (`terraform-sp`) for Terraform authentication.
- Explored MFA and Global Administrator access configuration in Azure Entra.
- Created project structure for `kingsila-cloud-portfolio`.
- Began setting up VS Code tracker for the 12-week Azure/Terraform/DevOps plan.

## 🕵️‍♂️ To Investigate Further
- Investigated Terraform backend error (`tfstate-rg` not found).
- Discovered backend `"azurerm"` block already present in repo.
- Understood that Terraform backend requires a **pre-created Azure Storage Account**.
- Decide whether to use **local state** temporarily or **bootstrap** the backend for remote state.

## 🧩 Issues & Fixes
| Issue | Root Cause | Resolution |
|--------|-------------|-------------|
| `Duplicate output definition` | Outputs duplicated across `main.tf` and `outputs.tf` | Removed duplicate outputs from `main.tf`. |
| Role assignment creation failed | Git Bash path conversion issue | Used PowerShell and `MSYS2_ARG_CONV_EXCL="*"` workaround. |

## 🚀 Next Steps
- Bootstrap Terraform backend storage account if remote state is desired.
- Start Week 1–2 tracker tasks (Azure Core + Governance).
- Verify local Terraform deployment with test `vnet` module.


## 🧠 Learnings
- Terraform backends don’t create their own infrastructure.
- Git Bash path conversion can break Azure CLI commands.
- Separate logic (`main.tf`) and outputs (`outputs.tf`) to avoid duplication.
- PowerShell provides a smoother experience for Azure CLI + Terraform workflows.

---
