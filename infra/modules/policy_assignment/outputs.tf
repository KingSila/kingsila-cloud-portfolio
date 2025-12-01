output "id" {
  description = "The ID of the policy assignment"
  value       = azurerm_subscription_policy_assignment.this.id
}

output "name" {
  description = "The name of the policy assignment"
  value       = azurerm_subscription_policy_assignment.this.name
}

output "scope" {
  description = "The scope of the policy assignment"
  value       = azurerm_subscription_policy_assignment.this.subscription_id
}

output "identity_principal_id" {
  description = "Principal ID of the managed identity used by the policy assignment (if any)"
  value       = try(azurerm_subscription_policy_assignment.this.identity[0].principal_id, null)
}

output "identity_type" {
  description = "Managed identity type of the policy assignment (if any)"
  value       = try(azurerm_subscription_policy_assignment.this.identity[0].type, null)
}
