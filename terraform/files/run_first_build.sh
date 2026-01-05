#!/bin/bash

set -euo pipefail

ecr_repo=$1
gh_repo=$2

if [ "$(aws ecr list-images --repository-name $ecr_repo --query 'length(imageIds)')" = "0" ]; then
  echo "ECR repository is empty. Triggering a build"
  curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/${gh_repo}/actions/workflows/build.yaml/dispatches \
    -d '{"ref":"main"}'
fi