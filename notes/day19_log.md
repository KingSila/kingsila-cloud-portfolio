# Daily Log – 2025-11-29 (Saturday)

## High-Level Summary
Continued refining Terraform + Azure Key Vault integration for **dev** and **test**. Resolved RBAC issues that blocked setting the `connection-string` secret and reached a point where **both dev and test environments work correctly** with Key Vault + App Service + Terraform in the loop.

---

## What I Worked On

### 1. Investigated Key Vault Forbidden Error (Test)
Error received when setting the secret in **kv-mainkingsila-test**:

> `Code: Forbidden`
> `Message: Caller is not authorized to perform action on resource.`
> `Inner error: { "code": "ForbiddenByRbac" }`

Details:
- Caller: Terraform/GitHub Service Principal (`appid=***`, `oid=be8514e5-2b03-4322-9810-1e7f97e7c14e`).
- Action: `Microsoft.KeyVault/vaults/secrets/setSecret/action`
- Assignment: `(not found)` – no RBAC role assignment found for that SP at the test Key Vault scope.

Conclusion:
- The SP didn’t have the correct **RBAC data-plane role** on **kv-mainkingsila-test** to set secrets.

---

### 2. Fixing RBAC for Test Environment
Work done to fix the issue conceptually (applied via portal/Terraform/CLI):

- Confirmed that Key Vault uses **Azure RBAC** for access control.
- Ensured the Terraform/GitHub Service Principal has a **Key Vault data role** at the test vault scope, such as:
  - `Key Vault Secrets Officer` (recommended), or
  - `Key Vault Administrator` (broader).

Once the role assignment was in place and RBAC propagation completed:

- Verified that setting the `connection-string` secret in **kv-mainkingsila-test** succeeds.
- Confirmed the same pattern works for **dev**, meaning both environments are consistent now.

---

### 3. Environment Consistency (Dev & Test)
- **Dev** and **Test** are now aligned in terms of:
  - Key Vault configuration.
  - Terraform Service Principal permissions.
  - Ability to set and manage the `connection-string` secret via IaC/automation.
- This removes environment-specific surprises and sets a standard pattern for future environments (e.g., `prod`).

---

## Current Status

- ✅ `connection-string` secret creation/updates now work in **dev**.
- ✅ `connection-string` secret creation/updates now work in **test**.
- ✅ Terraform/GitHub SPN has required roles for both Key Vaults.
- ✅ Path is clear for fully automated secret management through the pipeline.

---

## What’s Next

1. **Codify RBAC in Terraform (if not already)**
   - Ensure role assignments for Key Vault (dev/test) are **fully defined in Terraform**, e.g.:
     - `azurerm_role_assignment.kv_terraform_dev`
     - `azurerm_role_assignment.kv_terraform_test`
   - This guarantees consistent permissions whenever a new environment is deployed.

2. **Wire Secrets into App Service via Terraform**
   - Confirm App Service app settings use:
     ```hcl
     "ConnectionStrings__Db" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.app_secret.resource_versionless_id})"
     ```
   - Make sure `azurerm_key_vault_secret.app_secret` exists and is managed by Terraform for both dev and test.

3. **Pipeline Flow Polishing**
   - Tighten GitHub Actions workflow:
     - Per-environment `plan` / `apply` stages.
     - Explicit `TF_VAR_terraform_principal_object_id` and environment-specific variables.
   - Add guardrails for promotion:
     - e.g. dev → test flow, using the same patterns for secrets and permissions.

4. **Preparation for Prod**
   - Mirror the working dev/test pattern into a future **prod** environment:
     - Key Vault
     - RBAC roles
     - App Service secret references
     - Terraform + CI/CD pipeline steps

---

## Learnings

- RBAC errors like `ForbiddenByRbac` usually mean: *“your identity + scope + role”* triangle is broken somewhere.
- Treat **RBAC and Key Vault roles as code** (via Terraform) to avoid “it works in one environment but not the other”.
- Getting dev and test fully aligned now makes future environments (prod, staging, etc.) far less painful.

---
