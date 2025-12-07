resource "azurerm_key_vault" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  tenant_id = var.tenant_id
  sku_name  = "standard"

  # Use RBAC for data-plane (no access_policies)
  rbac_authorization_enabled = true

  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  public_network_access_enabled = true

  tags = var.tags
}
