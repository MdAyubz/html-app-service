#!/bin/bash

RESOURCE_GROUP="rg-devopsproj2"
AKS_CLUSTER="my-aks-cluster"

echo "⏳ Getting AKS credentials..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER

echo "🚀 Applying Kubernetes deployment..."
kubectl apply -f k8s/deployment.yaml

echo "✅ Deployment to AKS completed!"

