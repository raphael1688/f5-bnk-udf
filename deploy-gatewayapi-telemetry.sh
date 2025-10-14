#!/usr/bin/env bash

echo ""
echo "Install Promethues and Grafana ..."
kubectl apply -f resources/prometheus.yaml
kubectl apply -f resources/grafana.yaml

echo ""
echo "Install OTEL prerequired cert ..."
kubectl apply -f resources/otel-cert.yaml
