# Prod Environment Configuration

environment       = "prod"
allowed_locations = ["southafricanorth", "southafricawest", "global"]

location = "southafricanorth"

kubernetes_version = "1.34.0"

tags = {
  environment = "prod"
  project     = "cloud-native-portfolio"
  owner       = "kingsila"
}
