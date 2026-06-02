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

# ── Virtual Network ───────────────────────────────────────────
echo ""
echo "Creating virtual network..."
if az network vnet show --resource-group $RESOURCE_GROUP --name $VNET_NAME &>/dev/null; then
  echo "  Already exists — skipping"
else
  az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $SUBNET_NAME \
    --subnet-prefix 10.0.1.0/24
fi
