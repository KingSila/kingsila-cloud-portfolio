resource "azurerm_policy_definition" "this" {
  name         = var.name
  policy_type  = "Custom"
  mode         = "All"
  display_name = var.display_name
  description  = var.description

  # ✅ Use metadata to set category
  metadata = jsonencode({
    category = var.policy_category
  })

  # ✅ Policy rule for allowed locations
  policy_rule = <<POLICY_RULE
{
  "if": {
    "not": {
      "field": "location",
      "in": "[parameters('listOfAllowedLocations')]"
    }
  },
  "then": {
    "effect": "Deny"
  }
}
POLICY_RULE

  # ✅ Parameters schema
  parameters = <<PARAMETERS
{
  "listOfAllowedLocations": {
    "type": "Array",
    "metadata": {
      "description": "The list of allowed locations for resources.",
      "displayName": "Allowed locations"
    }
  }
}
PARAMETERS
}
