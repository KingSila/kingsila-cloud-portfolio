## Platform Guardrails – Deployment Location Policy

Our cloud platform enforces a subscription-level **Allowed Locations Policy** to ensure all resources are deployed only into approved Azure regions. This provides consistency, governance, and cost/security predictability across all environments.

---

### **What This Policy Does**

The policy denies any deployment where the target Azure region is *not* part of the allowed list defined for that environment.
If a resource attempts to deploy to a disallowed region, Azure Policy blocks the request before the resource is created.

---

### **Environments Covered**

This guardrail is applied to all environments managed by Terraform:

- **dev**
- **test**
- **prod**

Each environment can have its own region list, depending on business or compliance requirements.

---

### **Where Allowed Locations Are Configured**

Allowed regions are defined in two places:

1. **Environment tfvars files**
   Example:
   `infra/envs/dev/dev.tfvars`
   ```hcl
   allowed_locations = ["southafricanorth", "southafricawest"]


## Secret Management – End-to-End Flow

This section explains how application secrets (e.g. database connection strings) are handled across environments (**dev / test / prod**).

The goals of this design:

- No secrets in Terraform code or state
- No secrets in source control
- Consistent pattern across all environments
- Easy secret rotation without changing infra

---

### 1. Where Secrets Live

Secrets exist in two main places:

1. **GitHub Actions Secrets**
   - Per-environment values, e.g.:
     - `DEV_DB_CONNECTION_STRING`
     - `TEST_DB_CONNECTION_STRING`
     - `PROD_DB_CONNECTION_STRING`
   - These are the *source of truth* for sensitive values.
   - Stored encrypted inside GitHub, never committed to the repo.

2. **Azure Key Vault (per environment)**
   - One Key Vault per environment, created by Terraform:
     - `kv-main<owner>-dev`
     - `kv-main<owner>-test`
     - `kv-main<owner>-prod`
   - Used as the runtime secret store for applications.
   - Secrets are written into Key Vault by the CI pipeline.

Terraform **does not** store or manage secret values – only the Key Vault infrastructure.

---

### 2. How Secrets Move (Pipeline Flow)

For each environment, the CI/CD pipeline performs the following after a successful `terraform apply`:

1. Reads the correct connection string from GitHub Secrets:
   - `DEV_DB_CONNECTION_STRING`, `TEST_DB_CONNECTION_STRING`, or `PROD_DB_CONNECTION_STRING`.
2. Uses `terraform output -raw key_vault_name` to get the Key Vault name for that environment.
3. Calls Azure CLI to write/update the secret value in Key Vault, for example:

   ```bash
   az keyvault secret set \
     --vault-name "<kv-name>" \
     --name "connection-string" \
     --value "<connection-string-from-github-secret>"
