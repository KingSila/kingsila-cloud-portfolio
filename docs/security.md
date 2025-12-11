# 🔐 Kingsila Cloud Platform – Security Architecture

This document defines the full end-to-end security model of the Kingsila Cloud Platform.
It covers identity, governance, network boundaries, secrets lifecycle, continuous scanning, and naming standards across all environments (dev, test, prod).

The philosophy is simple:

**Secure-by-default. Enforce-by-policy. Automate-everything.**

---

## 1. Identity & Access Control

### 1.1 GitHub → Azure Authentication (OIDC)
The platform uses GitHub Actions **OpenID Connect (OIDC)**.
No client secrets, no SP credentials, no long-lived tokens.

Flow:
1. GitHub job requests federated token
2. Azure AD validates the claims
3. Short-lived access token issued
4. CI jobs authenticate without secrets

**Benefits:** Zero secret exposure, ephemeral credentials, minimal blast radius.

---

### 1.2 CI Workload Identity Permissions
The CI identity is granted the minimum necessary RBAC permissions:

- Contributor (restricted scope)
- Key Vault Secrets Officer (secret writes)
- Resource Policy Contributor (policy assignments)
- User Access Administrator (only where required)

UID-based, not SAS or static keys.

---

### 1.3 Application Identity (UAMI)
Apps (App Service, Functions, etc.) use **User-Assigned Managed Identity**.

Assigned roles:
- Key Vault Secrets User
- App-specific roles only

Apps retrieve secrets via Key Vault reference — no secrets stored in code or App Settings.

---

## 2. Secrets Lifecycle

### 2.1 Where Secrets Live
Secrets exist in two places:

- **GitHub Encrypted Secrets** → Source of truth for environment-specific values
- **Azure Key Vault** → Runtime secret store for applications

Nothing sensitive lives in Terraform state or code.

---

### 2.2 CI Secret Provisioning Flow
1. Pipeline retrieves secret from GitHub (e.g., `DEV_DB_CONNECTION_STRING`)
2. Authenticates to Azure via OIDC
3. Writes the secret to the environment Key Vault
4. Terraform references it via Key Vault reference:
   `@Microsoft.KeyVault(SecretUri=...)`

This provides:
- Auditable changes
- Automatic secret rotation
- Zero plaintext exposure

---

### 2.3 Key Vault RBAC Model
Key Vaults use **RBAC-only mode**:

```hcl
rbac_authorization_enabled = true
