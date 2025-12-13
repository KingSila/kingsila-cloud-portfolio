output "resource_group_name" {
  description = "Name of the dev resource group."
  value       = azurerm_resource_group.rg.name
}

output "webapp_url" {
  description = "URL of the dev web app."
  value       = module.app_service_dev.webapp_url
}

output "identity_id" {
  description = "User-assigned identity ID used by the dev app."
  value       = module.mi_app_dev.identity_id
}

#######################################################
# 7. Optional Outputs (handy for debugging)
#######################################################

output "dev_resource_group_name" {
  description = "Dev resource group name"
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
