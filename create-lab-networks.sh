#!/usr/bin/env bash

echo ""
echo "Creating docker networks external-net and egress-net and attach both to worker nodes ..."
docker network create -d macvlan external-net --subnet 192.0.2.0/24    --ipv6 --subnet 2001::192:0:2:0/112
docker network create -d macvlan egress-net   --subnet 198.18.100.0/24 --ipv6 --subnet 2001::198:18:100:0/112

docker network connect external-net bnk-worker
docker network connect egress-net   bnk-worker --ip 198.18.100.3 --ip6 2001::198:18:100:3
kubectl annotate --overwrite node   bnk-worker 'k8s.ovn.org/node-primary-ifaddr={"ipv4":"198.18.100.3", "ipv6":"2001::198:18:100:3"}'

docker network connect external-net bnk-worker2
docker network connect egress-net   bnk-worker2 --ip 198.18.100.4 --ip6 2001::198:18:100:4
kubectl annotate --overwrite node   bnk-worker2 'k8s.ovn.org/node-primary-ifaddr={"ipv4":"198.18.100.4", "ipv6":"2001::198:18:100:4"}'

docker network connect external-net bnk-worker3
docker network connect egress-net   bnk-worker3 --ip 198.18.100.5 --ip6 2001::198:18:100:5
kubectl annotate --overwrite node   bnk-worker3 'k8s.ovn.org/node-primary-ifaddr={"ipv4":"198.18.100.5", "ipv6":"2001::198:18:100:5"}'

docker network connect external-net bnk-worker4
docker network connect egress-net   bnk-worker4 --ip 198.18.100.6 --ip6 2001::198:18:100:6
kubectl annotate --overwrite node   bnk-worker4 'k8s.ovn.org/node-primary-ifaddr={"ipv4":"198.18.100.6", "ipv6":"2001::198:18:100:6"}'

echo "Flush IP on eth1 in each worker node, the node won't use it, only TMM will"
for node in $(docker ps --format "{{.Names}}" | grep "worker"); do
  echo -n $node
  docker exec -ti $node ip a flush eth1
done

