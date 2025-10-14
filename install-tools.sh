#!/usr/bin/env bash
source cluster.env

for node in control-plane worker worker2; do
  echo ""
  echo "node $cluster-$node ..."
  docker exec -ti $cluster-$node bash -c "apt-get update && apt-get install -y inetutils-ping tcpdump"
done
