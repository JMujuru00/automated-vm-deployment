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
# ── Network Security Group ────────────────────────────────────
echo ""
echo "Creating network security group..."
if az network nsg show --resource-group $RESOURCE_GROUP --name $NSG_NAME &>/dev/null; then
  echo "  Already exists — skipping"
else
  az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_NAME

  az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name AllowSSH \
    --priority 1000 \
    --protocol Tcp \
    --destination-port-range 22 \
    --access Allow
fi
# ── Public IP ─────────────────────────────────────────────────
echo ""
echo "Creating public IP address..."
if az network public-ip show --resource-group $RESOURCE_GROUP --name $PUBLIC_IP_NAME &>/dev/null; then
  echo "  Already exists — skipping"
else
  az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name $PUBLIC_IP_NAME \
    --sku standard \
    --allocation-method static
fi
# ── Network Interface Card ────────────────────────────────────
echo ""
echo "Creating network interface card..."
if az network nic show --resource-group $RESOURCE_GROUP --name $NIC_NAME &>/dev/null; then
  echo "  Already exists — skipping"
else
  az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name $NIC_NAME \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --network-security-group $NSG_NAME \
    --public-ip-address $PUBLIC_IP_NAME
fi
# ── Virtual Machine ───────────────────────────────────────────
echo ""
echo "Creating virtual machine..."
if az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME &>/dev/null; then
  echo "  Already exists — skipping"
else
  az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --nics $NIC_NAME \
    --image $IMAGE \
    --size $VM_SIZE \
    --admin-username $ADMIN_USER \
    --generate-ssh-keys
fi

# ── Output ────────────────────────────────────────────────────
echo ""
echo "Fetching public IP address..."
PUBLIC_IP=$(az network public-ip show \
  --resource-group $RESOURCE_GROUP \
  --name $PUBLIC_IP_NAME \
  --query ipAddress \
  --output tsv)

echo ""
echo "================================"
echo "  Deployment complete!"
echo "  Connect with:"
echo "  ssh $ADMIN_USER@$PUBLIC_IP"
echo "================================"
