# Daily Log — 2025-11-24

## 🧠 Summary
Today was a long trek through the land of Key Vault RBAC, federated identities, and Terraform tantrums. The dev environment finally behaved, the Key Vault permissions puzzle clicked into place, and the CI service principal was granted the correct powers after a heroic struggle with Azure’s occasionally cryptic RBAC machinery.

## 🚀 What Got Done
- Investigated and resolved 403 errors from Key Vault during Terraform apply.
- Identified the missing piece: Key Vault required proper **data-plane RBAC**, not just access policies.
- Updated configuration to use **RBAC mode**, replacing deprecated flags with the modern equivalent.
- Wired Terraform CI’s service principal correctly using object IDs instead of client IDs.
- Validated the Key Vault role assignment model via `access_identities`.
- Successfully deployed the **dev environment** with secrets creation working.
- Confirmed next steps for multi-environment rollout and CI improvements.

## ⚙️ Technical Wins
- Cleaned up RBAC model alignment across Key Vault and Terraform.
- Ensured GitHub Actions feeds the service principal’s **object ID** reliably into Terraform.
- Corrected role usage to **Key Vault Secrets Officer** for secret creation.
- Proved that the apply works in dev — the first victory in the trilogy.

## 😴 End-of-Day State
Brain: low battery.
Terraform: green.
Azure: temporarily cooperative.
You: absolutely ready for shutdown mode.

## 📝 Notes for Tomorrow
- Verify RBAC propagation and test CI-driven secret access.
- Prepare the pattern for **test** and **prod** environments.
- Add guardrails through GitHub Environments.
- Confirm `terraform destroy` works smoothly from CI.

Rest well — tomorrow we tame the next dragon.
