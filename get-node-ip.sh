#!/usr/bin/env bash
for node in $(docker ps --format "{{.Names}}" ); do
  echo ""
  echo $node
  docker exec -ti $node ip -br a | grep eth | sort
done
