# Common configuration
prefix              = "kingsila"
location            = "South Africa North"
resource_group_name = "rg-kingsila-dev"
vnet_name           = "vnet-kingsila-dev"
appsvc_subnet_name  = "snet-appsvc"

tags = {
  environment = "dev"
  owner       = "KingSila"
  project     = "CloudPortfolio"
}

# Security configuration
allowed_ssh_source = "192.168.18.3/32"
allowed_rdp_source = "192.168.18.3/32"

# Budget toggles
enable_diagnostics = true
log_retention_days = 30
enable_nat         = false
enable_bastion     = false

# App Service
appservice_sku    = "B1"
app_runtime_stack = "DOTNET|8.0" # or NODE|20-lts, PYTHON|3.12

# Optional inbound allowlist
# allowed_ips = ["YOUR.PUBLIC.IP.HERE"]
