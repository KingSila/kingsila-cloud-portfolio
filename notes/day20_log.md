# Daily Log — Terraform & Azure Policy Cleanup

## Date: 2025-11-30

---

## 🔧 Work Completed

### 1. Cleaned Up GitHub Secrets
- Removed duplicate environment connection string secrets.
- Consolidated project to a clean set:
  - `DB_CONNECTION_STRING_DEV`
  - `DB_CONNECTION_STRING_TEST`
  - `DB_CONNECTION_STRING_PROD`
  - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`
  - `TERRAFORM_PRINCIPAL_OBJECT_ID_DEV`, `TERRAFORM_PRINCIPAL_OBJECT_ID_TEST`
- Reduced clutter and ensured CI/CD uses the correct secrets.

---

### 2. Updated Allowed Azure Locations
- Replaced invalid regions with correct Azure slugs:
  - `southafricanorth`
  - `westafrica`
- Applied the update across Terraform variables.

---

### 3. Clarified Azure Policy Assignment Resource
- Discovered that `azurerm_policy_assignment` is **not** supported by the provider.
- Updated implementation to use:
  - `azurerm_resource_policy_assignment`
  - Confirmed compatibility with latest azurerm provider versions.
- Built a valid `main.tf` with:
  - Custom location restriction policy
  - Policy assignment module
  - Correct JSON-encoded parameters
  - Clean variable structure

---

### 4. Delivered Updated `infra/README.md`
- Added instructions for:
  - Running Terraform locally
  - Mapping `tfvars` to environments
  - Key Vault naming conventions
  - CI/CD behavior (PR, push, manual)
- Provided full monolithic `README.md` for direct repo inclusion.

---

## ⚙️ Outstanding / Next Steps
- Add prod principal object ID if CI/CD will deploy prod.
- Consider adding remediation tasks or managed identities for policy assignments.
- Standardize resource naming conventions for all modules.

---

## 📌 Summary
The day wrapped up with Terraform modules cleaned, policies corrected, secrets decluttered, and documentation aligned.
Everything now behaves more predictably, with fewer ghosts lurking in `tfvars` or GitHub secrets.
