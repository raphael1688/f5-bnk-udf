#!/usr/bin/env bash
kind delete cluster --name bnk
docker compose down || true
docker network prune -f
sudo rm -rf bnk-ga/rsyslog/logs/*
