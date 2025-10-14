#!/usr/bin/env bash

echo ""
echo "Install cert-manager and cluster issuer to manage pod-to-pod certs ..."
helm repo add jetstack https://charts.jetstack.io --force-update
helm upgrade --install -n cert-manager cert-manager jetstack/cert-manager --create-namespace --version v1.16.1 --set crds.enabled=true --wait
kubectl wait --for=condition=Ready pods --all -n cert-manager
kubectl apply -f resources/cluster-issuer.yaml

