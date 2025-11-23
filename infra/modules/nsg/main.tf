resource "azurerm_network_security_group" "this" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Example inbound rules
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.allowed_ssh_source
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.this.name
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "Allow-RDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.allowed_rdp_source
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.this.name
  resource_group_name         = var.resource_group_name
}

# Optional subnet association (only if provided)
resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each                  = var.subnet_ids
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.this.id
}
