# Daily Log – 2025-11-28

## Summary
Long RBAC wrestling session with Azure Key Vault and Terraform.
Terraform service principal now has a Key Vault RBAC role, but
`getSecret` for `connection-string` is still failing with `403 ForbiddenByRbac`.
Stopped for the day due to low energy – investigation to continue next session.

## What I Worked On

- Verified current Key Vault setup:
  - Confirmed `kv-kingsila-dev` is using **RBAC authorization**
    (`properties.enableRbacAuthorization = true`).
  - Listed existing role assignments on the Key Vault scope and confirmed:
    - Principal `32829e95-e812-40d5-9e34-49d583e8afd1`
    - Object ID `be8514e5-2b03-4322-9810-1e7f97e7c14e`
    - Role: **Key Vault Secrets Officer**

- Ran Terraform apply for dev environment:
  - `azurerm_role_assignment.kv_terraform_dev` created successfully for the Key Vault.
  - State lock acquired and released correctly.

- Hit the following error while managing the secret:
  - Resource: `azurerm_key_vault_secret.app_secret`
  - Secret name: `connection-string`
  - Vault: `kv-kingsila-dev` (westeurope)
  - Error:
    - `StatusCode=403 Code="Forbidden"`
    - `InnerError={"code":"ForbiddenByRbac"}`
    - Message indicating the caller is not authorized:
      - `Caller: appid=32829e95-e812-40d5-9e34-49d583e8afd1; oid=be8514e5-2b03-4322-9810-1e7f97e7c14e`
    - Hint from Azure:
      - `Assignment: (not found)` → RBAC evaluation not finding a valid assignment for this operation.

## Issues / Blockers

- Terraform fails on `azurerm_key_vault_secret.app_secret` with:
  - `keyvault.BaseClient#GetSecret` → `403 ForbiddenByRbac`
- Despite:
  - Key Vault RBAC being enabled.
  - Service principal having `Key Vault Secrets Officer` at Key Vault scope.
- Indicates a mismatch or gap between:
  - Identity used by Terraform at runtime, or
  - Effective RBAC evaluation for `secrets/getSecret/action` on `connection-string`.

## Next Steps (for future me)

- Reproduce the issue by logging in **as the Terraform service principal** and testing manually:
  - `az login --service-principal --username <APP_ID> --password <CLIENT_SECRET> --tenant <TENANT_ID>`
  - `az keyvault secret list --vault-name kv-kingsila-dev -o table`
- Double-check:
  - That the SP is using the same subscription/tenant as the Key Vault.
  - Whether there are any higher-level RBAC scopes (subscription / RG) that might conflict.
  - Key Vault network ACLs (`properties.networkAcls`) to ensure the SP’s traffic is allowed from the environment it runs in.
- Optionally:
  - Add or adjust role assignments (e.g. `Key Vault Administrator` temporarily) to test effective permissions.
  - Add debug notes/comments in Terraform and/or README for the Key Vault RBAC behavior.

## Mood / Energy

- Energy: 🔋 10% – low, time to stop before breaking things.
- Status: Wrapping up with a clear trail of breadcrumbs for next session.
