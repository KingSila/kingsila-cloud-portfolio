##############################
# RBAC – Subscription Level  #
##############################

# Admin / owner for you (or an AAD group you use)
resource "azurerm_role_assignment" "kingsila_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = var.kingsila_object_id
}

# GitHub Actions service principal – least privilege: Contributor
resource "azurerm_role_assignment" "github_actions_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = var.github_actions_sp_object_id

  # Optional: you can set `condition` / `description` later if you want
  # to be fancy with conditional access.
}
