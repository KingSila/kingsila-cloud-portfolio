output "key_vault_id" {
  value       = azurerm_key_vault.central.id
  description = "Central platform Key Vault resource ID"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.central.vault_uri
  description = "Central platform Key Vault URI"
}

output "aks_dev_subnet_id" {
  description = "Subnet ID for dev AKS"
  value       = azurerm_subnet.aks_dev.id
}

output "aks_test_subnet_id" {
  description = "Subnet ID for test AKS"
  value       = azurerm_subnet.aks_test.id
}

output "aks_prod_subnet_id" {
  description = "Subnet ID for prod AKS"
  value       = azurerm_subnet.aks_prod.id
}
