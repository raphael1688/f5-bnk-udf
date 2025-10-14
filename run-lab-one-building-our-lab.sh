#!/usr/bin/env bash

echo ""
echo "running steps in lab one"

./create-cluster.sh
./deploy-cni.sh
./create-lab-networks.sh
./create-bigip-network-attachements.sh
./create-router-and-client-containers.sh

echo ""

