# Common configuration

environment            = "prod"
location               = "southafricanorth"
prod_connection_string = "REPLACE_ME_FROM_PIPELINE_OR_LOCAL"
vnet_cidr              = "10.10.0.0/16"
app_sku                = "B1"

tags = {
  environment = "prod"
  owner       = "kingsila"
}
allowed_locations = ["southafricanorth", "southafricawest"]
