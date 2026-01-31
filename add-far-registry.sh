#!/usr/bin/env bash

echo ""
echo "F5 Artifacts Registry (FAR) authentication token ..."

# Read the content of cne_pull_64.json into the SERVICE_ACCOUNT_KEY variable
SERVICE_ACCOUNT_KEY=$(tar zxOf ~/far/f5-far-auth-key.tgz)
# Create the SERVICE_ACCOUNT_K8S_SECRET variable by appending "_json_key_base64:" to the base64 encoded SERVICE_ACCOUNT_KEY
SERVICE_ACCOUNT_K8S_SECRET=$(echo "_json_key_base64:${SERVICE_ACCOUNT_KEY}" | base64 -w 0)

echo "Create the secret.yaml file with the provided content ..."
cat << EOF > ~/far/far-secret.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: far-secret
data:
  .dockerconfigjson: $(echo "{\"auths\": {\
\"repo.f5.com\":\
{\"auth\": \"$SERVICE_ACCOUNT_K8S_SECRET\"}}}" | base64 -w 0)
type: kubernetes.io/dockerconfigjson
EOF

kubectl -n f5-operators apply -f ~/far/far-secret.yaml
kubectl -n f5-utils apply -f ~/far/far-secret.yaml
kubectl -n default  apply -f ~/far/far-secret.yaml

echo $SERVICE_ACCOUNT_KEY | helm registry login -u _json_key_base64 --password-stdin --password-stdin repo.f5.com

