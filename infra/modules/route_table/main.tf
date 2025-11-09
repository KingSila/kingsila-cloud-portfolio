resource "azurerm_route_table" "this" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags = var.tags
}

# Example route: send all Internet traffic via Internet
resource "azurerm_route" "internet_route" {
  name                   = "InternetRoute"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.this.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "Internet"
}

# Associate route table with subnets
resource "azurerm_subnet_route_table_association" "assoc" {
  for_each           = var.subnet_ids
  subnet_id          = each.value
  route_table_id     = azurerm_route_table.this.id
}
