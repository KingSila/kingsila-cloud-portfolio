resource "azurerm_subscription_policy_assignment" "this" {
  name                 = var.name
  subscription_id      = var.subscription_id
  policy_definition_id = var.policy_definition_id
  display_name         = var.display_name
  description          = var.description


  # parameters must be JSON-encoded
  parameters = length(var.parameters) > 0 ? jsonencode(var.parameters) : null

  # location is required when using identity/remediation
  location = var.identity_type != "" ? var.location : null

  dynamic "identity" {
    for_each = var.identity_type != "" ? [1] : []
    content {
      type = var.identity_type
    }
  }
}
