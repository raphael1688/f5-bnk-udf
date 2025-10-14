#!/usr/bin/env bash
for node in $(docker ps --format "{{.Names}}" | grep "worker"); do
  echo ""
  echo $node
  docker exec -ti $node sh -c "ip -br link show type vxlan | awk '{print \$1}' | xargs -I{} ethtool --offload {} tx off"
done

