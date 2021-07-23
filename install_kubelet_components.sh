#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

# Install Docker.
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt update
apt install -qy docker-ce

# Set up Kubernetes.
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
# We hardcode "xenial" (16.04) here because bionic (18.04) does not have official Kubernetes packages yet.
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update
apt install -y kubectl kubelet kubeadm kubernetes-cni
