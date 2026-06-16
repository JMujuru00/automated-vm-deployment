# Automated VM Deployment — Azure CLI

Bash scripts to automate the deployment of a Linux VM on Microsoft Azure,
including all required networking resources. Reduces manual deployment 
from ~20 minutes to under 2 minutes.

## Tech Stack
- Azure CLI (`az`)
- Bash
- Azure: Resource Groups, VMs, VNets, NSGs, Public IPs, NICs

## Features
- Fully automated deployment of all Azure networking and compute resources
- Idempotent — safe to re-run without duplicating resources
- Parameterised via config file — reusable across environments
- Teardown script to delete all resources and avoid unnecessary charges
- SSH key authentication — no passwords

## Prerequisites
- Azure CLI installed (`az --version`)
- Active Azure subscription (`az login`)
- Bash (Linux, macOS, or WSL on Windows)

## Project Structure
automated-vm-deployment/
├── scripts/
│   ├── deploy.sh       # Provisions all Azure resources and VM
│   └── teardown.sh     # Destroys all resources cleanly
├── config/
│   └── vm-config.env   # All configurable values in one place
└── README.md

## Usage
```bash
# 1. Clone the repo
git clone https://github.com/JMujuru00/automated-vm-deployment
cd automated-vm-deployment

# 2. Edit config if needed
nano config/vm-config.env

# 3. Deploy
bash scripts/deploy.sh

# 4. Connect to your VM
ssh azureuser@<public-ip-shown-at-end>

# 5. Tear down when done
bash scripts/teardown.sh
```

## Resources Created
Each resource is created explicitly in the correct dependency order:
1. Resource Group — container for all resources
2. Virtual Network + Subnet — private network space (10.0.0.0/16)
3. Network Security Group — firewall rules (SSH port 22 open)
4. Public IP — static internet-facing address
5. Network Interface Card — connects VM to the network
6. Virtual Machine — Ubuntu 24.04 LTS

## What I Learned
- How Azure networking components relate and must be provisioned in order
- Writing idempotent Bash scripts using existence checks before creating resources
- SSH key generation and injection into VMs programmatically
- Troubleshooting real Azure errors including SKU availability restrictions
  across regions and race conditions in resource provisioning
- Azure CLI command structure and how to query specific fields from JSON output
- How to query specific Azure CLI variables 
