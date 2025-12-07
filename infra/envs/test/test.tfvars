# Common configuration

environment            = "test"
location               = "southafricanorth"
test_connection_string = "REPLACE_ME_FROM_PIPELINE_OR_LOCAL"
vnet_cidr              = "10.20.0.0/16"
app_sku                = "B1"

tags = {
  environment = "test"
  owner       = "kingsila"
}
allowed_locations = ["southafricanorth", "southafricawest"]
