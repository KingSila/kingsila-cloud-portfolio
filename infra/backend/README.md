# Terraform Backend Bootstrap

This folder contains the Terraform configuration to create the Azure resources needed for remote state storage.

## Resources Created

- Resource Group: `tfstate-rg`
- Storage Account: `tfstatekingsila`
- Blob Container: `state`

## Setup Instructions

### 1. Initialize and Apply (First Time Only)

```powershell
# Navigate to backend folder
cd infra/backend

# Initialize Terraform (uses local state)
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

### 2. After Creation

Once these resources are created, your environment configurations (dev/test/prod) can use them for remote state storage.

## Important Notes

- This configuration uses **local state** (no backend block)
- Run this **only once** to bootstrap the backend infrastructure
- Keep the local state file (`terraform.tfstate`) in a safe place or commit it to version control
- The storage account has versioning enabled for state file protection
