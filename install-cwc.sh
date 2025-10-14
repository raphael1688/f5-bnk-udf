#!/usr/bin/env bash

echo ""
echo "Install Cluster Wide Controller (CWC) to manage license and debug API ..."
helm pull oci://repo.f5.com/utils/f5-cert-gen --version 0.9.3  --untar --untardir ~/cwc
mv ~/cwc/f5-cert-gen ~/cwc/cert-gen
pushd ~/cwc && sh cert-gen/gen_cert.sh -s=api-server -a=f5-spk-cwc.f5-utils -n=1 && popd
kubectl apply -f ~/cwc/cwc-license-certs.yaml -n f5-utils

echo "Create directory for API client certs for easier reference ..."
pushd ~/cwc && \
  mkdir -p cwc_api && \
  cp api-server-secrets/ssl/client/certs/client_certificate.pem \
  api-server-secrets/ssl/ca/certs/ca_certificate.pem \
  api-server-secrets/ssl/client/secrets/client_key.pem \
  cwc_api
popd

echo ""
echo "Adding name for CWC service name for client access ..."
#NODE_IP=$(kubectl  get node bnk-worker -o jsonpath='{.status.addresses[0].address}') && \
#echo "$NODE_IP  f5-spk-cwc.f5-utils" | sudo tee -a /etc/hosts

