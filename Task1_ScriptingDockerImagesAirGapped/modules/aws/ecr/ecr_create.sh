#!/bin/bash

function create_ecr_repository() {
    local repository_name=$1
    local region=$2
    

    for images in ${IMAGE_LIST[@]}; do
        
        imagetag=${images##*/}
        imagenotag="$( cut -d ':' -f 1 <<< "$imagetag" )"
        
        echo "Creating ECR repository: $repository_name/$imagenotag"

        aws ecr create-repository --repository-name "$repository_name/$imagenotag" --region "$region"  --image-tag-mutability IMMUTABLE --image-scanning-configuration scanOnPush=true  &> /dev/null

        if [[ $? -eq 0 ]];then
            show_error $? "AWS ECR repo: $repository_name/$imagenotag on region: ${CLOUD_REGION} created successfully"
        elif [[ $rc -eq 254 ]]; then
            show_error $? "AWS ECR repo: $repository_name/$imagenotag on region: ${CLOUD_REGION} already exists"
        else
            show_error $? "Failed to create AWS ECR repo: $repository_name/$imagenotag on region: ${CLOUD_REGION}"
        fi
        
    done
}