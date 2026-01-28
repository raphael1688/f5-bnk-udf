#!/usr/bin/env bash

echo ""
echo "Install Promethues and Grafana ..."
kubectl apply -f resources/prometheus.yaml
kubectl apply -f resources/grafana.yaml

echo ""
echo "Install OTEL prerequired cert ..."
kubectl get ns f5-operators || kubectl create ns f5-operators
kubectl apply -f resources/otel-cert.yaml -n f5-operators
