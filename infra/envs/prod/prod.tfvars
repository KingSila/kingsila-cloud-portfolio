# Prod Environment Configuration

location = "southafricanorth"

# Use a distinct CIDR if you ever peer VNets:
vnet_cidr = "10.30.0.0/16"

# You can bump this later when you want more capacity
app_sku = "B1"

tags = {
  owner       = "kingsila"
  environment = "prod"
}
