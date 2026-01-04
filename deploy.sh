#!/bin/bash

set -euo pipefail

cd terraform

terraform init
terraform apply --auto-approve

echo "The web app is publicly accessible on $(terraform output -raw app_url)"