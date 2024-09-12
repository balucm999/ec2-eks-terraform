#!/bin/bash

# Download Istio 1.22.0
curl -L -o istio-1.22.0-linux-amd64.tar.gz https://github.com/istio/istio/releases/download/1.22.0/istio-1.22.0-linux-amd64.tar.gz

# Extract the downloaded tarball
tar -xzf istio-1.22.0-linux-amd64.tar.gz

# Move to the Istio directory
cd istio-1.22.0

# Add Istio's bin directory to the system PATH
export PATH=$PWD/bin:$PATH

# Persist the PATH change
echo 'export PATH=$PWD/bin:$PATH' >> ~/.bashrc

# Reload the shell to apply PATH changes
source ~/.bashrc

# Install Istio using the demo profile
istioctl install --set profile=demo -y

# Deploy Kiali dashboard addon
kubectl apply -f samples/addons/kiali.yaml
kubectl apply -f samples/addons/prometheus.yaml
# Expose Kiali service as LoadBalancer
kubectl patch svc kiali -n istio-system -p '{"spec": {"type": "LoadBalancer"}}'
