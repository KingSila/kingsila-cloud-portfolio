# Environments Overview

This document describes the configuration differences and shared baseline across dev, test, and prod.

---

## 1. Shared Baseline
All environments share:

- Azure Policies
- Tagging standards
- VNet topology
- AKS architecture
- Workload identity
- Key Vault structure
- Monitoring setup

---

## 2. Environment Differences

### dev
- Lowest cost SKUs
- App Insights always enabled
- Experimental modules deployed first

### test
- Mirrors prod sizing
- Used for integration testing
- Policies enforced equally to prod

### prod
- Mission-critical configuration
- All policies enforced, no exemptions
- Node pools scaled appropriately
- Additional RBAC restrictions applied

---

## 3. Variables per Environment

Example (`dev.tfvars`):
```hcl
environment      = "dev"
location         = "southafricanorth"
allowed_locations = ["southafricanorth"]
node_count       = 1
