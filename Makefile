all: cluster lab requirements bnk tenants

cluster:
	./create-cluster.sh
	./deploy-cni.sh
	kubectl get node

lab:
	./create-lab-networks.sh
	./create-bigip-network-attachements.sh
	./create-router-and-client-containers.sh

requirements:
	./add-inotify-limits.sh
	./create-cert-manager.sh
	./deploy-gatewayapi-telemetry.sh
	./create-f5-namespaces.sh
	./add-far-registry.sh
	./install-cwc.sh

bnk:
	./install-bnk.sh

tenants:
	./create-tenants.sh

red:
	kubectl apply -f resources/nginx-red-deployment.yaml
	kubectl apply -f resources/nginx-red-gw-api.yaml

blue:
	kubectl apply -f ./resources/nginx-blue-deployment.yaml

clean:
	./destroy-cluster.sh
