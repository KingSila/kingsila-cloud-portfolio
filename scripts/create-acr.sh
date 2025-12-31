#!/usr/bin/env bash
set -euo pipefail

# ====== VARIABLES ======
LOCATION="southafricanorth"
RG_NAME="rg-kingsila-platform"
ACR_NAME="acrkingsilaplatform"   # must be globally unique, lowercase
SKU="Basic"

# Tags
TAGS=(
  environment=shared
  owner=KingSila
  project=cloud-native-platform
  layer=platform
  costcenter=platform
)

# ====== ENSURE RG EXISTS ======
az group create \
  --name "$RG_NAME" \
  --location "$LOCATION" \
  --tags "${TAGS[@]}"

# ====== CREATE ACR ======
az acr create \
  --resource-group "$RG_NAME" \
  --name "$ACR_NAME" \
  --sku "$SKU" \
  --admin-enabled false \
  --tags "${TAGS[@]}"

# ====== VERIFY ======
az acr show \
  --resource-group "$RG_NAME" \
  --name "$ACR_NAME" \
  --query "{name:name, loginServer:loginServer, sku:sku.name, tags:tags}" \
  -o jsonc
