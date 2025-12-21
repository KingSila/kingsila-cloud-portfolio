# Create Azure context config (do not commit real values)
az aks command invoke -g rg-kingsila-dev -n aks-kingsila-dev \
  --command "kubectl -n dev create configmap azure-context --from-literal=subscriptionId=$ARM_SUBSCRIPTION_ID --dry-run=client -o yaml | kubectl apply -f -"
