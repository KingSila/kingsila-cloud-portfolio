#############################
# Resource Group
#############################

output "resource_group_name" {
  description = "The name of the Resource Group for this environment."
  value       = azurerm_resource_group.rg.name
}

#############################
# Key Vault
#############################

output "keyvault_name" {
  description = "Central platform Key Vault name"
  value       = module.central_key_vault.name
}

output "keyvault_uri" {
  description = "Central platform Key Vault URI"
  value       = module.central_key_vault.uri
}

#############################
# App Service
#############################

output "app_service_plan_name" {
  description = "The name of the App Service Plan."
  value       = azurerm_service_plan.app.name
}

output "webapp_name" {
  description = "The name of the deployed Web App."
  value       = azurerm_linux_web_app.app.name
}

output "webapp_url" {
  description = "The default hostname of the Web App."
  value       = azurerm_linux_web_app.app.default_hostname
}

#############################
# Networking
#############################

output "vnet_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "nsg_name" {
  description = "The name of the network security group."
  value       = azurerm_network_security_group.nsg.name
}

output "route_table_name" {
  description = "The name of the route table."
  value       = azurerm_route_table.rt.name
}

output "prod_app_identity_client_id" {
  description = "Client ID of the user-assigned managed identity used by the prod app"
  value       = module.mi_app_prod.client_id
}
