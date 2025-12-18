output "resource_group_name" {
  description = "Name of the test resource group."
  value       = azurerm_resource_group.rg.name
}

output "webapp_url" {
  description = "URL of the test web app."
  value       = module.app_service_test.webapp_url
}

output "identity_id" {
  description = "User-assigned identity ID used by the test app."
  value       = module.mi_app_test.identity_id
}

#######################################################
# 7. Optional Outputs (handy for debugging)
#######################################################

output "test_resource_group_name" {
  description = "test resource group name"
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.name
}

output "aks_subnet_id" {
  description = "AKS subnet ID from platform VNet"
  value       = data.azurerm_subnet.aks.id
}

output "wi_app_test_client_id" {
  description = "Client ID for the test AKS workload identity"
  value       = module.wi_app_test.client_id
}
