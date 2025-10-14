#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

trap 'unset DEBIAN_FRONTEND' ERR EXIT


# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get install -y make htop btop jq tmux mosh net-tools bwm-ng tcpdump snapd 

sudo usermod -aG docker $USER

# k9s
if [ $(uname -m) = aarch64 ]; then
  wget https://github.com/derailed/k9s/releases/download/v0.50.15/k9s_linux_arm64.deb
  sudo dpkg -i k9s_linux_arm64.deb && rm -f k9s_linux_arm64.deb
else
  wget https://github.com/derailed/k9s/releases/download/v0.50.15/k9s_linux_amd64.deb
  sudo dpkg -i k9s_linux_amd64.deb && rm -f k9s_linux_amd64.deb
fi

# kind
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-arm64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# helm & kubectl
sudo snap install helm --classic
sudo snap install kubectl --classic

unset DEBIAN_FRONTEND
