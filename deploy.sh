#!/bin/bash

set -euo pipefail

cd terraform

terraform init
terraform apply --auto-approve

#echo "The web app is publicly accessible on $(terraform output -raw app_url)"
alb_hostname=`kubectl -n hello-app get ingress hello-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`
echo "The web app is publicly accessible on http://$alb_hostname"