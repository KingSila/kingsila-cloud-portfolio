# ----------------------------
# Dev Environment Configuration
# ----------------------------

environment       = "dev"
allowed_locations = ["southafricanorth", "southafricawest"]

location = "southafricanorth"


# App Service SKU (if used in your module)
app_sku = "B1"


kubernetes_version = "1.34.0"

tags = {
  environment = "dev"
  project     = "cloud-native-portfolio"
  owner       = "kingsila"
}
