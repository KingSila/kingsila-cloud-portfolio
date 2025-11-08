# 🗓️ Daily Notes – Friday, 8 November 2025

## 🎯 Focus Area
Azure · Terraform Backend Setup · Provider Configuration Best Practices

## ✅ Tasks Completed
- Created dedicated `infra/backend/` folder for Terraform state infrastructure.
- Generated `main.tf` for backend bootstrap (Resource Group, Storage Account, Container).
- Successfully applied Terraform to create remote state backend resources.
- Resolved provider version conflicts between modules and environments.
- Implemented Terraform best practice: removed provider blocks from reusable modules.
- Fixed vnet module to inherit provider configuration from root modules.
- Successfully initialized and applied Terraform in dev environment with remote backend.

## 🕵️‍♂️ To Investigate Further
- Deprecation warning for `storage_account_name` in `azurerm_storage_container` resource.
- Learned it's deprecated in favor of `storage_account_id` (planned for v5.0 removal).
- Decision: Keep current configuration as warning is non-blocking.

## 🧩 Issues & Fixes
| Issue | Root Cause | Resolution |
|--------|-------------|-------------|
| `terraform init` tries to use remote backend | Backend block configured in `main.tf` | Created bootstrap folder to provision backend resources first. |
| Provider version conflict (~> 3.115.0 vs ~> 4.51.0) | Modules and environments had different versions | Removed provider blocks from modules; only root modules define versions. |
| Deprecation warning on `storage_account_name` | Azure provider v3.x preparing for v5.0 changes | Kept as-is; warning is informational only. |

## 🚀 Next Steps
- Apply same module cleanup pattern to other modules (nsg, storage, aks) if needed.
- Set up test and prod environments with remote backend.
- Begin implementing actual Azure infrastructure resources.
- Continue with Week 1–2 tracker tasks (Azure Core + Governance).

## 🧠 Learnings
- **Backend Bootstrap Pattern**: Backend infrastructure needs local state, then environments use it for remote state.
- **Module Best Practice**: Modules should NOT contain `terraform {}` or `provider {}` blocks.
- **Provider Inheritance**: Modules automatically inherit provider configuration from calling root modules.
- **Version Management**: Define provider versions only in root modules (environments, bootstrap).
- **Separation of Concerns**: Backend infrastructure lives in its own folder, separate from environments.

---
