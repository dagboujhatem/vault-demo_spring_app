#!/bin/bash
set -e
cd "$(dirname "$0")"

echo ">>> Step 1: Waiting for Terraform to configure Vault..."
until [ "$(docker inspect -f {{.State.Running}} terraform 2>/dev/null)" == "false" ]; do
    echo "Waiting for Terraform..."
    sleep 2
done
echo "Terraform configuration complete."
sleep 2
