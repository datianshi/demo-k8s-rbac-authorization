#decode the token
kubectl config set-credentials sa-sample --token=$(kubectl get secret/sa-sample-secret -n demo-authz -o json | jq -r .data.token | base64 --decode)
kubectl config set-context nsxt --user=sa-sample
