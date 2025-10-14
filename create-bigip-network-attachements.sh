#!/usr/bin/env bash

echo "Create Multus Network Attachments ..."
kubectl apply -f resources/networks.yaml

echo ""
kubectl get network-attachment-definitions
