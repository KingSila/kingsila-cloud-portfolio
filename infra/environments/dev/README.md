# Development Environment - Terraform Configuration

Azure infrastructure deployment for the **KingSila Cloud Portfolio** development environment.

## 📋 Overview

This environment deploys:
- ✅ Virtual Network (VNet) with app and data subnets
- ✅ Network Security Groups (NSG) with SSH/RDP rules
- ✅ Route Tables for subnet associations
- ✅ Remote state management in Azure Storage

**Region:** South Africa North
**Resource Group:** `rg-kingsila-dev`
**Environment:** Development

---

## 🏗️ Architecture

```text
rg-kingsila-dev (Resource Group)
├── vnet-kingsila-dev (10.10.0.0/16)
│   ├── app subnet (10.10.1.0/24)
│   └── data subnet (10.10.2.0/24)
├── nsg-app-dev (Network Security Group)
│   ├── Allow SSH (port 22)
│   └── Allow RDP (port 3389)
└── dev-route-table (Route Table)
```

---

## ⚙️ Prerequisites

### Required Tools
- **Azure CLI** (logged in)
  ```powershell
  az login
  az account show
  ```
- **Terraform** >= 1.9.0
  ```powershell
  terraform version
  ```

### Backend Requirements
Ensure the backend storage exists (created via `infra/backend/`):
- Resource Group: `tfstate-rg`
- Storage Account: `tfstatekingsila`
- Container: `state`

---

## 🚀 Deployment Steps

### 1. Configure Variables

Edit `terraform.tfvars` with your settings:

```hcl
location            = "South Africa North"
resource_group_name = "rg-kingsila-dev"

tags = {
  environment = "dev"
  owner       = "KingSila"
  project     = "CloudPortfolio"
}

# Replace with your actual IP address
allowed_ssh_source = "203.0.113.10/32"
allowed_rdp_source = "203.0.113.10/32"
```

### 2. Initialize Terraform

```powershell
cd C:\source\kingsila-cloud-portfolio\infra\environments\dev
terraform init
```

Downloads providers and configures the Azure backend.

### 3. Plan Changes

```powershell
terraform plan -var-file="terraform.tfvars"
```

Review the resources that will be created.

### 4. Apply Configuration

```powershell
terraform apply -var-file="terraform.tfvars"
```

Type `yes` to confirm and deploy resources.

### 5. Verify Deployment

```powershell
# List resources in Azure
az resource list --resource-group rg-kingsila-dev --output table

# View Terraform outputs
terraform output
```

---

## 📦 Resources Created

| Resource Type | Name | Purpose |
|---------------|------|---------|
| Resource Group | `rg-kingsila-dev` | Container for all dev resources |
| Virtual Network | `vnet-kingsila-dev` | Network isolation (10.10.0.0/16) |
| Subnet (App) | `app` | Application tier (10.10.1.0/24) |
| Subnet (Data) | `data` | Data tier (10.10.2.0/24) |
| NSG | `nsg-app-dev` | Security rules for both subnets |
| Route Table | `dev-route-table` | Custom routing configuration |

---

## 🔧 Configuration Variables

### Required Variables
- `allowed_ssh_source` - Your public IP for SSH access (CIDR format)
- `allowed_rdp_source` - Your public IP for RDP access (CIDR format)

### Optional Variables (with defaults)
- `location` - Azure region (default: "South Africa North")
- `resource_group_name` - RG name (default: "rg-kingsila-dev")
- `tags` - Resource tags

---

## �️ Cleanup

To destroy all resources:

```powershell
terraform destroy -var-file="terraform.tfvars"
```

**Warning:** This permanently deletes all resources. State file remains in Azure Storage.

---

## 📝 Notes

- **State Backend:** Remote state stored in Azure Blob Storage
- **Module Structure:** Follows Terraform best practices with reusable modules
- **Security:** NSG rules restrict SSH/RDP to specified source IPs only
- **Extensibility:** Easy to replicate for test/prod environments

---

## 🔗 Related Documentation

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Virtual Networks](https://docs.microsoft.com/azure/virtual-network/)
- [Network Security Groups](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview)

---

**Last Updated:** November 9, 2025
**Maintained By:** KingSila
