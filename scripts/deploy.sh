#!/bin/bash
set -e

# ── Load config ───────────────────────────────────────────────
source config/vm-config.env

echo "Starting deployment..."
echo "Resource Group : $RESOURCE_GROUP"
echo "Location       : $LOCATION"
echo "VM Name        : $VM_NAME"

# ── Resource Group ────────────────────────────────────────────
echo ""
echo "Creating resource group..."
if az group show --name $RESOURCE_GROUP &>/dev/null; then
  echo "  Already exists — skipping"
else
  az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION
fi
