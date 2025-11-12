#!/bin/bash
#example usage: ./deploy_infra.sh prod
set -e 

ENV=$1
cd environments/$ENV
terraform init
terraform apply -target=module.vpc -target=module.eks -auto-approve
terraform apply -auto-approve

aws eks --region us-east-1 update-kubeconfig --name ${ENV}-eks-cluster 
kubectl apply -f ../../../bootcamp-gitops/environments/applicationset.yaml

echo "Waiting for ingress hostname..."
while true; do
  WEBSITE=$(kubectl get ingress -n psychometry-app-${ENV} -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)
  if [[ -n "$WEBSITE" ]]; then
    break
  fi
  sleep 5
done
echo "Ingress hostname: $WEBSITE"

HOSTEDZONE=$(aws route53 list-hosted-zones \
  --query "HostedZones[?Name=='teomim.site.'].Id" \
  --output text | sed 's|/hostedzone/||')

aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE --change-batch "{
  \"Changes\": [{
    \"Action\": \"UPSERT\",
    \"ResourceRecordSet\": {
      \"Name\": \"${ENV}.teomim.site.\",
      \"Type\": \"CNAME\",
      \"TTL\": 300,
      \"ResourceRecords\": [{\"Value\": \"${WEBSITE}\"}]
    }
  }]
}"


echo "Application URL: http://${ENV}.teomim.site"