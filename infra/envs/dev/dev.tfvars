# Common configuration

environment = "dev"
location    = "southafricanorth"
vnet_cidr   = "10.10.0.0/16"
app_sku     = "B1"

tags = {
  environment = "dev"
  owner       = "kingsila"
}
allowed_locations = ["southafricanorth", "southafricawest"]
