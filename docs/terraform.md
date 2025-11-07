# Terraform Implementation Notes

## 🔹 Project Layout

infra/
modules/
vnet/
nsg/
storage/
aks/
environments/
dev/
test/
prod/


## 🔹 Remote State
```hcl
backend "azurerm" {
  resource_group_name  = "tfstate-rg"
  storage_account_name = "tfstatekingsila"
  container_name       = "state"
  key                  = "global.terraform.tfstate"
}


