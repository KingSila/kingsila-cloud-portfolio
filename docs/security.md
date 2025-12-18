# Security Architecture

This document describes the security controls implemented across the Kingsila Cloud Platform.
All environments (dev, test, prod) follow the same security baseline unless otherwise noted.

---

## 1. Azure Policy

Azure Policy enforces governance requirements at the subscription level.
All policies are deployed via Terraform in:

- `modules/policy_definition_*`
- `modules/policy_assignment`
- `infra/envs/<env>/main.tf`

### 1.1 Allowed Locations Policy
**Name:** `allowed-locations-<env>`
**Purpose:** Restrict resource creation to approved Azure regions.
**Where defined:**
`modules/policy_definition_allowed_locations`

**How to modify locations:**
Edit `allowed_locations` in `<env>.tfvars`, then re-apply Terraform.

### 1.2 Require Environment Tag on All Resources
**Name:** `require-environment-tag`
**Definition ID:** `871b6d14-10aa-478d-b590-94f262ecfa99`
**Purpose:** Ensures every resource includes an `environment` tag.
**Behavior:** Blocks creation of untagged resources, including AKS-managed VMSS.

### 1.3 Require Owner Tag on All Resources
**Name:** `require-owner-tag`
**Definition ID:** `871b6d14-10aa-478d-b590-94f262ecfa99` (same definition reused)
**Purpose:** Ensures traceability for cloud assets.

### 1.4 Deny Public Storage Accounts
**Name:** `deny-public-storage`
**Purpose:** Prevent exposure of blob containers and storage accounts to public networks.
**Notes:** Requires a managed identity for the policy assignment (Modify effect).

---

## 2. Identity & Access

### 2.1 Workload Identity (AKS)
AKS uses Azure AD Workload Identity to issue tokens to pods.
Components:

- Federated identity in Azure AD
- User-assigned Managed Identity for the AKS workload
- Terraform module: `modules/workload_identity`

### 2.2 Key Vault Access
Access to Key Vault is controlled with RBAC roles:

- `Key Vault Secrets User` for application identities
- `Key Vault Administrator` only for tightly scoped CI/CD access
- Terraform creates secret references into App Service and AKS workloads.

---

## 3. Networking Security

### 3.1 Private Endpoints
Key Vault and AKS rely on private endpoints and Private DNS Zones:
- `privatelink.vaultcore.azure.net`
- `privatelink.southafricanorth.azmk8s.io`

### 3.2 AKS Network Controls
- System and user node pools deployed to dedicated subnets
- No public IP exposure
- NSGs enforce inbound/outbound rules according to shared baseline

---

## 4. Data Protection

- Key Vault uses soft delete and purge protection
- No storage account without private endpoints (enforced via policy)

---

## 5. Monitoring & Defender

- Defender for Cloud enabled for Containers, App Services, Storage
- Container Insights enabled for AKS
- Application Insights linked to Web Apps
