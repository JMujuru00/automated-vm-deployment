#!/bin/bash
set -e

# ── Load config ───────────────────────────────────────────────
source config/vm-config.env

echo "WARNING: This will delete $RESOURCE_GROUP and everything inside it."
echo "This includes the VM, VNet, NSG, Public IP and NIC."
echo ""
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "Aborted."
  exit 0
fi

echo ""
echo "Deleting resource group: $RESOURCE_GROUP"
az group delete \
  --name $RESOURCE_GROUP \
  --yes \
  --no-wait

echo ""
echo "================================"
echo "  Teardown initiated."
echo "  Resources will be gone"
echo "  within a few minutes."
echo "================================"
