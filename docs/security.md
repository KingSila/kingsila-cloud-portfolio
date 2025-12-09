# Security Overview

## Central Key Vault (Platform Layer)

A single, platform-level Key Vault (`kv-kingsila-platform`) stores shared and environment-specific secrets.
It is deployed in the `rg-kingsila-platform` resource group, which is never destroyed.
This ensures secrets, connection strings, and long-lived credentials remain stable across infrastructure changes.

Key points:
- RBAC is enabled; access is controlled through Azure AD roles.
- Network ACLs are configured for "deny by default" with `AzureServices` bypass.
- GitHub Actions OIDC service principal is granted the minimum role required to set and update secrets.
- Application environments (dev/test/prod) reference this vault but do not create or modify it.

---

## Secrets Flow (GitHub → Key Vault → Application)

Secrets are never stored in Terraform code or state.
The flow for all environments is:

1. **GitHub Actions environment secrets**
   Each environment stores its connection string or sensitive configuration in GitHub Actions (e.g. `DEV_DB_CONNECTION_STRING`, `TEST_DB_CONNECTION_STRING`, `PROD_DB_CONNECTION_STRING`).

2. **CI pipeline writes secrets to Platform Key Vault**
   During deployment, Terraform reads the GitHub secret and writes it into the central Key Vault as:
   - `dev-connection-string`
   - `test-connection-string`
   - `prod-connection-string`

3. **Application reads secrets from Key Vault**
   Applications use Managed Identity, and App Service uses Key Vault references in app settings:
   ```
   @Microsoft.KeyVault(SecretUri=<secret-uri>)
   ```
   This keeps connection strings and other sensitive values out of code and configuration files.

This pattern ensures:
- No secrets in source control.
- No secrets in Terraform state.
- Consistent handling across all environments.

---

## Allowed-Locations Policy

The Allowed-Locations Azure Policy restricts where resources may be deployed for each environment.
This prevents accidental creation of infrastructure in unauthorized regions.

### Purpose
- Enforce compliance with the organization's region strategy.
- Prevent drift by blocking deployments to regions outside the approved list.

### Where the Code Lives
- Policy definition module:
  `modules/policy_definition_allowed_locations`
- Policy assignment module:
  `modules/policy_assignment`
- Environment-level wiring:
  `infra/envs/<env>/main.tf`

### How to Change Allowed Locations
1. Edit the `<env>.tfvars` file (e.g. `dev.tfvars`, `test.tfvars`, `prod.tfvars`)
2. Update the `allowed_locations` variable:
   ```hcl
   allowed_locations = ["southafricanorth", "southafricawest"]
   ```
3. Commit the change and re-apply Terraform for that environment.

The policy assignment will automatically update to reflect the new allowed region list.

---
