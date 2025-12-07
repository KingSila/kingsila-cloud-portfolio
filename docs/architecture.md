# 🏗️ Cloud Platform Architecture Summary

## Overview

This project implements a **multi-environment, modular, cloud-native platform** on Azure using Terraform.
The architecture separates **permanent platform resources** from **ephemeral application environments**, allowing dev/test/prod to be safely recreated while keeping identity, security, and governance stable.

Design principles:

1. **Platform is permanent** – identity, RBAC, secrets, and governance live here.
2. **Environments are ephemeral** – dev/test/prod can be destroyed and recreated freely.
3. **Modules are reusable** – ensuring consistent deployments across all environments.

---

## 🔐 Platform Layer (Permanent)

The `platform` environment provisions all shared foundational resources.

### Key Components

- **Resource Group:** `rg-kingsila-platform`
- **Central Key Vault:** `kv-kingsila-platform`
  - RBAC-enabled (no access policies)
  - Stores:
    - `dev-connection-string`
    - `test-connection-string`
    - `prod-connection-string`
- **GitHub OIDC Identity + RBAC**
  - Azure AD federated identity for CI/CD
  - Assigned **Key Vault Secrets Officer**
- **Permanent Managed Identities (optional)**
  - For shared services or future expansion

### Purpose

Provides a stable, secure foundation for all workloads.
Centralizes secret management and access control.

---

## 🌱 Application Environments (Ephemeral)

Each environment (`dev`, `test`, `prod`) has its own Terraform root module:


### Environment Components

- **Resource Group**
  - Dev: `rg-kingsila-dev`
  - Test: `rg-kingsila-test`
  - Prod: `rg-kingsila-prod`
- **User-Assigned Managed Identity**
  - Created per environment
  - Granted Key Vault access by *platform*
  - Used by App Service at runtime
- **App Service Plan + Linux Web App**
  - Deployed using the shared `app_service` module
  - Identity-enabled
  - Reads secrets from platform Key Vault (Key Vault reference)

### Terraform State Isolation

Each environment maintains its own remote state file:

- `dev/terraform.tfstate`
- `test/terraform.tfstate`
- `prod/terraform.tfstate`

### Purpose

Allows rapid environment creation/destruction without affecting the platform or other environments.

---

## 🧩 Module Architecture

Reusable modules live in:


### `managed_identity_app`
- Creates a user-assigned managed identity
- Assigns Key Vault RBAC
- Outputs identity ID

### `app_service`
- Creates an App Service Plan
- Deploys a Linux Web App
- Assigns UAMI to the app
- Injects Key Vault secret references into app settings

### Benefits

- Eliminates duplication
- Ensures consistency
- Reduces maintenance burden
- Prevents environment drift

---

## 🚀 CI/CD Workflow

GitHub Actions manages automated deployment for all environments.

### Pull Requests

- Runs **terraform plan** for dev/test/prod
- Validates formatting and module integrity

### Push to `main`

- Runs **plan + apply** for all environments
- Uses GitHub → Azure OIDC authentication (no secrets stored in CI)

### Manual Deployment

- `workflow_dispatch` supports running any environment directly

### Terraform Steps

- `init`
- `validate`
- `plan`
- `apply`

Secrets are **never deployed from CI**.
Instead, apps retrieve secrets directly from Key Vault at runtime using their managed identity.

---

---

## 🎯 Summary

This architecture provides:

- Strong centralized security (Key Vault + RBAC)
- Zero credentials in CI/CD (OIDC-based auth)
- Full environment isolation
- Safe destroy/recreate workflows
- Consistency through reusable modules
- Predictable and stable deployments

It forms a clean, scalable foundation for growing the platform over time.
