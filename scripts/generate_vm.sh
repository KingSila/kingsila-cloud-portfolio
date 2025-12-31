#!/usr/bin/env bash
set -euo pipefail

# ---------------------------
# Variables
# ---------------------------
RG_VM="rg-kingsila-test"
LOCATION="southafricanorth"

VM_NAME="gh-runner-aks-test"
VM_SIZE="Standard_B2s"
IMAGE="Ubuntu2204"

VNET_RG="rg-kingsila-platform"
VNET_NAME="vnet-kingsila-platform"
SUBNET_NAME="snet-aks-test"

ADMIN_USER="azureuser"
SSH_KEY="$HOME/.ssh/id_rsa.pub"

# Required policy tags
TAG_OWNER="KingSila"     # change if your org expects email or shortname
TAG_ENV="test"               # dev/test/prod, etc.

TAGS="owner=${TAG_OWNER} environment=${TAG_ENV}"

# ---------------------------
# Pre-flight: SSH key
# ---------------------------
if [ ! -f "$SSH_KEY" ]; then
  echo "SSH key not found, generating one..."
  ssh-keygen -t rsa -b 4096 -f "${SSH_KEY%.pub}" -N ""
fi
echo "Using SSH key: $SSH_KEY"

# ---------------------------
# Get subnet ID
# ---------------------------
SUBNET_ID="$(az network vnet subnet show \
  -g "$VNET_RG" \
  --vnet-name "$VNET_NAME" \
  -n "$SUBNET_NAME" \
  --query id -o tsv)"

echo "Subnet ID: $SUBNET_ID"

# ---------------------------
# Create NIC (tagged)
# ---------------------------
NIC_NAME="${VM_NAME}-nic"

az network nic create \
  -g "$RG_VM" \
  -n "$NIC_NAME" \
  --subnet "$SUBNET_ID" \
  --location "$LOCATION" \
  --tags $TAGS \
  -o none

# ---------------------------
# Create VM (tagged)
# ---------------------------
az vm create \
  -g "$RG_VM" \
  -n "$VM_NAME" \
  --location "$LOCATION" \
  --nics "$NIC_NAME" \
  --image "$IMAGE" \
  --size "$VM_SIZE" \
  --admin-username "$ADMIN_USER" \
  --ssh-key-values "$(cat "$SSH_KEY")" \
  --os-disk-size-gb 30 \
  --public-ip-address "" \
  --tags $TAGS \
  -o jsonc

echo "✅ VM $VM_NAME deployed in $RG_VM with tags: $TAGS"
