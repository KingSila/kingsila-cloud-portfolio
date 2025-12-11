# 🔐 Security Architecture – KingSila Cloud Platform

This document describes the security model that underpins the KingSila Cloud Platform.
It covers identity flows, governance guardrails, secret lifecycle, and CI/CD scanning.

Last updated: **2025-12-10**

---

# 1. Platform Structure & Security Boundaries

The platform is split into **two Terraform layers**, each with its own scope and security responsibilities.

## 1.1 Root Layer (`infra/`)
**Purpose:** Subscription-wide governance.

Contains:
- Azure Policy assignments
- Defender for Cloud baseline
- Tag enforcement
- Allowed regions
- Deny public endpoint guardrails

Does **not** contain:
- Resource groups
- VNets
- Key Vaults for workloads
- App Services
- Any workload resources

This layer defines *what is allowed* globally and enforces compliance.

## 1.2 Environment Layers (`infra/envs/dev|test|prod`)
**Purpose:** Deploy workload resources for each isolated environment.

Each environment owns:
- Its own Resource Group
- Its own VNet + Subnets + NSGs
- Its own App Service Plan + App Service
- Its own identity bindings
- Its own App Configuration (via Key Vault references)

All environments **consume secrets from a single central Key Vault** (platform layer).

---

# 2. Centralised Key Vault Model

The platform contains **one Key Vault**:



It stores all environment secrets:

| Secret Name                  | Used By |
|------------------------------|---------|
| `dev-connection-string`      | dev app |
| `test-connection-string`     | test app |
| `prod-connection-string`     | prod app |

### Why this model?
- Secrets are in **one immutable, non-destroyable** location.
- Environments can be destroyed/recreated without touching secrets.
- RBAC is centrally applied.
- CI/CD only needs access to one vault.

### 2.1 App Service → Key Vault Reference
Each environment uses:

```hcl
ConnectionStrings__Db = "@Microsoft.KeyVault(SecretUri=https://kv-kingsila-platform.vault.azure.net/secrets/${var.tags.environment}-connection-string/)"
