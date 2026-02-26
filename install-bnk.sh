#!/usr/bin/env bash

echo ""
echo "Install BNK ..."
# BGP ConfigMap that includes ZebOS config
kubectl apply -f resources/zebos-bgp-cm.yaml
kubectl label node bnk-worker2 app=f5-tmm
kubectl label node bnk-worker3 app=f5-tmm
echo ""
echo "taint bnk-worker2 and bnk-worker3 to make them explicitly dedicated to TMM"
kubectl taint node bnk-worker2 dpu=true:NoSchedule || true
kubectl taint node bnk-worker3 dpu=true:NoSchedule || true

echo ""
echo "disable tx checksum on vxlan interfaces"
# It may be required to run this script again if the egress traffic
# does not work. Sometimes the vxlan interface may not yet exist.
./tx-offload-disable.sh

echo ""
for node in $(docker ps -f name=bnk --format '{{.Names}}' | grep "worker"); do
  echo "Set ECMP policy on node $node to L4"
  docker exec $node sysctl -w net.ipv4.fib_multipath_hash_policy=1
  docker exec $node sysctl -w net.ipv4.conf.all.rp_filter=2
  docker exec $node sysctl -w net.ipv4.conf.default.rp_filter=2
  docker exec $node sysctl -w net.ipv4.conf.eth2.rp_filter=2
done

export JWT=$(cat ~/.jwt)
envsubst < resources/flo-value.yaml >/tmp/flo-value.yaml
unset JWT
helm upgrade --install flo oci://repo.f5.com/charts/f5-lifecycle-operator --version v2.9.27-0.2.10 -f /tmp/flo-value.yaml --namespace f5-operators

#sleep 10
kubectl wait --for=condition=Ready pods --all -n f5-operators --timeout=120s || true
#sleep 10

echo ""
echo "Install CNI instance for Kubernetes ..."
kubectl apply -f resources/cne-instance.yaml
sleep 10
kubectl wait --for=condition=Ready pods -l app.kubernetes.io/name=f5-lifecycle-operator -A --timeout=120s || true
