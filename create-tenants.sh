#!/usr/bin/env bash

echo ""
echo "Create red tenant namespace..."
kubectl create ns red || true

echo ""
echo "Create blue tenant namespace..."
kubectl create ns blue || true

echo ""
echo "Creating VLANs for tenant ingress"
n=0
until kubectl apply -f resources/vlans.yaml || [ $n -ge 30 ]; do
  n=$((n + 1))
  echo "trying again in 10 secs ($n times) ..."
  sleep 10
done

sleep 10
kubectl wait --for=condition=Programmed f5-spk-vlan --all --timeout=300s


echo ""
echo "Install SNAT Pools to be selected on egress for tenant namespaces"
kubectl apply -f resources/snat-pool.yaml
sleep 20
kubectl apply -f resources/egress.yaml
sleep 20

echo ""
echo "Little lab hack to disable TX offload capabilities on egress vxlans"
./tx-offload-disable.sh

echo ""
echo "Install a global logging profile for all tenants"
kubectl apply -f resources/bnk-global-options.yaml
kubectl apply -f resources/bnk-logging.yaml

echo ""
echo "Install Grafana dashboard"
curl -X POST -H 'Content-Type: application/json' -d @resources/grafana-dashboard.json http://admin:admin@localhost:3000/api/dashboards/db
curl -X POST -H 'Content-Type: application/json' -d @resources/grafana-dashboard2.json http://admin:admin@localhost:3000/api/dashboards/db


