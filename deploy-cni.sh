#!/usr/bin/env bash

echo "Create CNI and Multus ..."
kubectl apply -f resources/calico.yaml
kubectl apply -f resources/multus.yaml
kubectl apply -f resources/cni-plugins-$(uname -m).yaml

echo ""
echo "Waiting for Kubernetes control plane to get ready ..."
kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout 180s
