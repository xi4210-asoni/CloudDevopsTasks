#!/bin/bash

func ecr_cache_repo_create() {
    echo "Creating Cache Repo Upstream"
    aws ecr create-pull-through-cache-rule --ecr-repository-prefix $ECRCACHEREPONAME --upstream-registry-url $ECRCACHEREPOUPSTREAM --region $CLOUD_REGION
    if [[$? -eq 0]]; then
        show_error $? "AWS ECR Cache Repo created: $ECRCACHEREPONAME in region: $CLOUD_REGION" 
    elif [[ $? -eq 254 ]]; then
        show_error $? "AWS ECR Cache Repo already created:  $ECRCACHEREPONAME in region: $CLOUD_REGION"
    else
        show_error $? "AWS ECR Cache Repo not created"
    fi
}