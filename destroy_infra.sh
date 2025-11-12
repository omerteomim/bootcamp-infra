#!/bin/bash
#example usage: ./destroy_infra.sh prod

set -e

ENV=$1

# echo "Deleting alb"
# ALB_ARN=$(aws elbv2 describe-load-balancers \
#     --query "LoadBalancers[?contains(LoadBalancerName,'psychometry')].LoadBalancerArn | [0]" \
#     --output text)
# aws elbv2 delete-load-balancer --load-balancer-arn $ALB_ARN

echo "Removing CNAME record for ${ENV}.teomim.site"
HOSTEDZONE=$(aws route53 list-hosted-zones \
  --query "HostedZones[?Name=='teomim.site.'].Id" \
  --output text | sed 's|/hostedzone/||')

# Fetch the current CNAME value
CURRENT_VALUE=$(aws route53 list-resource-record-sets \
  --hosted-zone-id $HOSTEDZONE \
  --query "ResourceRecordSets[?Name=='${ENV}.teomim.site.'] | [?Type=='CNAME'].ResourceRecords[0].Value" \
  --output text)

aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE --change-batch "{
  \"Changes\": [{
    \"Action\": \"DELETE\",
    \"ResourceRecordSet\": {
      \"Name\": \"${ENV}.teomim.site.\",
      \"Type\": \"CNAME\",
      \"TTL\": 300,
      \"ResourceRecords\": [{\"Value\": \"${CURRENT_VALUE}\"}]
    }
  }]
}"

echo "Deleted CNAME record for ${ENV}.teomim.site"

echo "Destroying infrastructure for environment: $ENV"
cd environments/$ENV
terraform init
terraform destroy -auto-approve
