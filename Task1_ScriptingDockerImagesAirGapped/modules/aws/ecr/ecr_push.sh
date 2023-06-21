#!/bin/bash

# Function to login to ECR
function login_to_ecr() {
  local login_password=$1

  echo "Logging in to ECR..."
  echo "$login_password" | docker login --username AWS --password-stdin "$AWSACCOUNTID".dkr.ecr."$CLOUD_REGION".amazonaws.com

  if [[ $? -eq 0 ]]; then
    Log INFO "AWS ecr login configured successfully for account id: ${AWSACCOUNTID}"
  else
    Abort 255 "Failed to login AWS ECR account id: ${AWSACCOUNTID}"
  fi

}

# Function to push image to ECR
function push_image_to_ecr() {
  local pull_image=$1           
  local source_image=$2
  local target_image=$3
  local tag=$4
  
  docker pull "$pull_image:${tag}" &> /dev/null
  if [[ $? -eq 0 ]]; then
    Log INFO "Image pull success: ${pull_image}:${tag}"
  else
    Abort 255 "Failed to pull docker image: ${pull_image}:${tag}"
  fi

  docker tag "$pull_image:$tag" "$target_image:$tag" &> /dev/null
  
  docker push "$target_image:$tag" 
  if [[ $? -eq 0 ]]; then
    Log INFO "Image push success: ${target_image}:${tag}"
  else
    Abort 255 "Failed to push docker image: ${target_image}:${tag}"
  fi
}


## ECR push images
function ecr_run() {
    
    # Build ECR repository
    create_ecr_repository "$REPONAME" "$CLOUD_REGION" 

    # Creds for ecr login
    ecr_login=$(aws ecr get-login-password --region "$CLOUD_REGION")

    # Login to the ecr
    login_to_ecr "$ecr_login"

    for image in "${IMAGE_LIST[@]}"; do
      #Dividing the names in different formats
      pull_image=$(echo "$image" | awk -F ':' '{print $1}' )
      echo ---------------------------
      echo $pull_image
      source_image=$(echo "$image" | awk -F '/' '{print $NF}' | awk -F ':' '{print $1}' )
      echo ---------------------------
      echo $source_image
      target_image="$AWSACCOUNTID.dkr.ecr.$CLOUD_REGION.amazonaws.com/$REPONAME/$source_image"
      echo ---------------------------
      echo $target_image
      tag=$(echo "$image" | awk -F ':' '{print $2}')
      echo ---------------------------
      echo $tag
      push_image_to_ecr "$pull_image" "$source_image" "$target_image" "$tag" 
    done
}