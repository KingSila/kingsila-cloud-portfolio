
data "azurerm_client_config" "current" {}


resource "azurerm_subscription_policy_assignment" "this" {
  name                 = var.name
  display_name         = var.display_name
  description          = var.description
  subscription_id      = "/subscriptions/${var.subscription_id}"
  policy_definition_id = var.policy_definition_id
  enforce              = var.enforce

  # parameters is an HCL block type in azurerm 4.x
  parameters = var.parameters != null ? jsonencode(var.parameters) : null
}
