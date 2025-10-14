#!/usr/bin/env bash
set -e
set -x
kubectl get f5-spk-vlan
#kubectl get f5-spk-vxlan
echo ""
docker exec -ti infra-frr-1 vtysh -c "show bgp summary"
docker exec -ti infra-frr-1 vtysh -c "show ip route"
echo ""
echo "Testing virtual server (ingress) ..."
docker exec -ti infra-client-1 curl -I http://198.19.19.100
echo ""
echo "Testing egress from red namespace ..."
kubectl exec -ti -n red deploy/nginx-deployment -- curl 198.51.100.100/txt
echo ""
echo "Testing ingress to blue service. ..."
docker exec -ti infra-client-1 curl -I http://198.20.20.100


echo  ""
echo "Test ingress to blue service after applying reject ACL. This should fail ..."
kubectl apply -f resources/bnk-acl-blue.yaml
sleep 5
set +e
docker exec -ti infra-client-1 curl -I http://198.20.20.100
status=$?
echo "status is $status"
if [ $status -eq 7 ]; then
    echo "Success: curl to blue service was denied."
else
    echo "ACL blue namespace ingress failed"
    exit 1
fi

echo ""
echo "Removing ACL configuration"
kubectl delete -f resources/bnk-acl-blue.yaml


echo ""
echo "Validation successful!"
