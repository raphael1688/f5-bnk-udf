#!/usr/bin/env bash

echo ""
echo "running steps for lab two"

./create-cert-manager.sh
./deploy-gatewayapi-telemetry.sh
./create-f5util-namespace.sh
./add-far-registry.sh
./install-cwc.sh
./install-bnk.sh
./create-tenants.sh

echo ""
