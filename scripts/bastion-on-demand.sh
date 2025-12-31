#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# On-demand Azure Bastion script
# Usage:
#   ./bastion-on-demand.sh up
#   ./bastion-on-demand.sh down
#   ./bastion-on-demand.sh status
# -----------------------------

# === Config (edit these) ===
RG="rg-kingsila-platform"
LOCATION="southafricanorth"          # change if needed
VNET="vnet-kingsila-platform"

# Bastion resources
BASTION_NAME="bastion-kingsila-dev"
PIP_NAME="pip-bastion-dev"

# Bastion requires this subnet name exactly
BASTION_SUBNET="AzureBastionSubnet"

# SKU: Basic is cheapest (Standard adds features)
BASTION_SKU="Basic"

# Tags
TAGS=(owner="Silas.Mokone" environment="dev")

# -----------------------------
log() { printf "\n[%s] %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; }

require_az() {
  command -v az >/dev/null 2>&1 || { echo "az CLI not found in PATH"; exit 1; }
}

ensure_bastion_extension() {
  # Avoid prompts for extensions
  az config set extension.use_dynamic_install=yes_without_prompt >/dev/null
  # Trigger install if missing
  az extension show --name bastion >/dev/null 2>&1 || az extension add --name bastion >/dev/null
}

check_subnet() {
  log "Checking that subnet '$BASTION_SUBNET' exists in VNet '$VNET'..."
  if ! az network vnet subnet show -g "$RG" --vnet-name "$VNET" -n "$BASTION_SUBNET" >/dev/null 2>&1; then
    echo "ERROR: Subnet '$BASTION_SUBNET' not found."
    echo "Bastion requires a subnet named EXACTLY 'AzureBastionSubnet'."
    echo "Create it like this (example /24):"
    echo "  az network vnet subnet create -g $RG --vnet-name $VNET -n AzureBastionSubnet --address-prefixes 10.0.255.0/24"
    exit 1
  fi
}

pip_up() {
  log "Creating Public IP '$PIP_NAME' (Standard, Static)..."
  # Bastion requires Standard Public IP
  az network public-ip create \
    -g "$RG" -n "$PIP_NAME" -l "$LOCATION" \
    --sku Standard --allocation-method Static \
    --tags "${TAGS[@]}" >/dev/null
}

bastion_up() {
  log "Creating Bastion '$BASTION_NAME' (SKU: $BASTION_SKU)..."
  az network bastion create \
    -g "$RG" -n "$BASTION_NAME" -l "$LOCATION" \
    --vnet-name "$VNET" \
    --public-ip-address "$PIP_NAME" \
    --sku "$BASTION_SKU" \
    --tags "${TAGS[@]}"
}

up() {
  require_az
  ensure_bastion_extension
  check_subnet

  # Create PIP if missing
  if az network public-ip show -g "$RG" -n "$PIP_NAME" >/dev/null 2>&1; then
    log "Public IP '$PIP_NAME' already exists. Skipping."
  else
    pip_up
  fi

  # Create Bastion if missing
  if az network bastion show -g "$RG" -n "$BASTION_NAME" >/dev/null 2>&1; then
    log "Bastion '$BASTION_NAME' already exists. Skipping."
  else
    bastion_up
  fi

  log "Done. Bastion is provisioned (billing runs while it exists)."
}

down() {
  require_az
  ensure_bastion_extension

  log "Deleting Bastion '$BASTION_NAME'..."
  az network bastion delete -g "$RG" -n "$BASTION_NAME" -y || true

  log "Deleting Public IP '$PIP_NAME'..."
  az network public-ip delete -g "$RG" -n "$PIP_NAME" || true

  log "Done. Bastion and its PIP are gone (billing stops)."
}

status() {
  require_az
  ensure_bastion_extension

  log "Bastion status:"
  if az network bastion show -g "$RG" -n "$BASTION_NAME" >/dev/null 2>&1; then
    az network bastion show -g "$RG" -n "$BASTION_NAME" --query "{name:name,sku:sku.name,provisioning:provisioningState,id:id}" -o table
  else
    echo "Not found."
  fi

  log "Public IP status:"
  if az network public-ip show -g "$RG" -n "$PIP_NAME" >/dev/null 2>&1; then
    az network public-ip show -g "$RG" -n "$PIP_NAME" --query "{name:name,sku:sku.name,allocation:publicIPAllocationMethod,ip:ipAddress}" -o table
  else
    echo "Not found."
  fi
}

case "${1:-}" in
  up) up ;;
  down) down ;;
  status) status ;;
  *)
    echo "Usage: $0 {up|down|status}"
    exit 1
    ;;
esac
