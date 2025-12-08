# ----------------------------
# Dev Environment Configuration
# ----------------------------

environment       = "dev"
allowed_locations = ["southafricanorth", "southafricawest"]

location = "southafricanorth"

# Network
vnet_cidr = "10.10.0.0/16"

# App Service SKU (if used in your module)
app_sku = "B1"

# Tags
tags = {
  owner       = "kingsila"
  environment = "dev"
}
