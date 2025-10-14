#!/usr/bin/env bash

kind get kubeconfig --name bnk >/dev/null 2>&1
if  [ $? -ne 0 ]; then
  kind  create cluster --config resources/kind.yaml --name bnk
fi

echo ""
kubectl cluster-info --context kind-bnk

