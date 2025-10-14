#!/usr/bin/env bash

echo "Create f5-operators and f5-utils namespaces for BNK supporting software"
kubectl create ns f5-operators || true
kubectl create ns f5-utils || true
