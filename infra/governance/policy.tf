##############################
# Baseline Policy – Simple   #
##############################

resource "azurerm_policy_definition" "allowed_locations" {
  name         = "ks-allowed-locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "KS Allowed Locations"

  metadata = jsonencode({
    category = "General"
  })

  parameters = jsonencode({
    listOfAllowedLocations = {
      type = "Array"
      metadata = {
        description = "The list of allowed locations for resources."
        displayName = "Allowed locations"
      }
    }
  })

  policy_rule = <<POLICY
{
  "if": {
    "not": {
      "field": "location",
      "in": "[parameters('listOfAllowedLocations')]"
    }
  },
  "then": {
    "effect": "deny"
  }
}
POLICY
}

# 🔁 NEW: Subscription-scope policy assignment
resource "azurerm_subscription_policy_assignment" "allowed_locations_assign" {
  name                 = "ks-allowed-locations-assignment"
  display_name         = "KS Allowed Locations"
  policy_definition_id = azurerm_policy_definition.allowed_locations.id

  subscription_id = data.azurerm_subscription.current.id

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}
