#!/bin/bash

RESOURCE_GROUP="rg-devopsproj2"
AKS_CLUSTER="aksvm-devo"
#"my-aks-cluster"

echo "⏳ Getting AKS credentials..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER

echo "🚀 Applying Kubernetes deployment..."
#kubectl apply -f k8/deployment.yaml
#kubectl apply -f k8/service.yaml
kubectl apply -f /home/mohammedaz/devopsproj-3/deployment.yaml
kubectl apply -f /home/mohammedaz/devopsproj-3/service.yaml

echo "✅ Deployment to AKS completed!"

