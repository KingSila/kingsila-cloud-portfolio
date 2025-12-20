#!/usr/bin/env bash
set -euo pipefail

# Namespace for the ingress controller
kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.replicaCount=1 \
  --set controller.ingressClassResource.name=nginx \
  --set controller.ingressClassResource.controllerValue="k8s.io/ingress-nginx" \
  --set controller.ingressClassByName=true
