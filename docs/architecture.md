# Kingsila Cloud Platform – Architecture Overview

This document outlines the platform design deployed across dev, test, and prod environments.

---

## 1. High-Level Diagram

Core components:
- Virtual Network (per environment)
- AKS Cluster (per environment)
- App Service + Plan
- Key Vault (shared or per environment)
- Azure Policy enforcement
- CI/CD via GitHub Actions
- Monitoring (App Insights / Container Insights)

---

## 2. Infrastructure Components

### 2.1 Resource Groups
Each environment uses:
- `rg-kingsila-<env>`
- Managed RG for AKS: `MC_rg-kingsila-<env>_aks-kingsila-<env>_<region>`

### 2.2 Networking
- VNet: `vnet-kingsila-<env>`
- Subnets:
  - `aks-subnet`
  - `app-subnet`
  - `private-endpoints-subnet`
- Private DNS zones linked to the VNet

### 2.3 AKS Cluster
Terraform module: `modules/aks`

Key features:
- Private cluster
- System + user node pools
- Node pool tags required for policy compliance
- Workload identity integration
- Metrics + logs shipped to Log Analytics

### 2.4 App Service
Terraform module: `modules/app_service`

Includes:
- Linux App Service Plan
- Web App with UAMI
- App Insights (optional per env)
- Key Vault secret references

### 2.5 Key Vault
Terraform module: `modules/keyvault`

Purpose:
- Store secrets per environment
- Provide central access for workloads via managed identity

---

## 3. Policy Integration

Azure Policy is deployed before any environment to avoid drift.
Policies enforced:

- Allowed Locations
- Required Tags
- Deny Public Storage
- Environment-specific allowed region definitions

Policies run at subscription scope and apply automatically to all resources.

---

## 4. CI/CD Pipeline Architecture

- GitHub Actions validate + plan on PR
- Main branch auto-applies to each environment
- tfsec integrated for security scanning
- Provider caching enabled for faster Terraform runs

---

## 5. Environment Lifecycle

### dev
- Main testing ground for new modules
- Lower SKU resources
- App Insights used for validation

### test
- Mirrors prod for stability checks
- Policies identical to prod
- Performance tests target this environment

### prod
- Fully locked-down
- Highest policy enforcement
- Strict tagging
- Workload identity required for all workloads

---

## 6. Future Enhancements (Roadmap)
- Ingress controller with AGIC or NGINX
- Internal load balancer for private traffic
- Centralized secret rotation
- Baseline landing zone modules
