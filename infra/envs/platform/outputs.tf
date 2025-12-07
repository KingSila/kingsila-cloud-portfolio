output "key_vault_id" {
  value       = azurerm_key_vault.central.id
  description = "Central platform Key Vault resource ID"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.central.vault_uri
  description = "Central platform Key Vault URI"
}
