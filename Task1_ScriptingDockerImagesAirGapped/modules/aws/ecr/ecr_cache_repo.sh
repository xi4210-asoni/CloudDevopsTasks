#!/bin/bash

function ecr_cache_repo_create() {
    typeset -i ec
    echo "Creating Cache Repo Upstream"
    aws ecr create-pull-through-cache-rule --ecr-repository-prefix $ECRCACHEREPONAME --upstream-registry-url $ECRCACHEREPOUPSTREAM --region $CLOUD_REGION 2> /dev/null
    ec=$?
    if [[ $ec -eq 0 ]]; then
        Log INFO "AWS ECR Cache Repo created: $ECRCACHEREPONAME in region: $CLOUD_REGION" 
    elif [[ $ec -eq 254 ]]; then
        Log WARN "AWS ECR Cache Repo already created:  $ECRCACHEREPONAME in region: $CLOUD_REGION"
    else
        Abort 255 "AWS ECR Cache Repo not created"
    fi
}