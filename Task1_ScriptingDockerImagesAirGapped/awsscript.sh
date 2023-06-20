#!/bin/bash

yaml_file="/root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/awsdetails.yaml"

# Fetch parameters using yq
cloudProvider=$(yq eval '.cloudProvider' "$yaml_file")
cloudRegion=$(yq eval '.cloudRegion' "$yaml_file")
repoName=$(yq eval '.ecrRepoName' "$yaml_file")
accountId=$(yq eval '.accountId' "$yaml_file")
imagesList=($(yq eval '.imagesList[]' "$yaml_file"))    #Use this to fetch all the images into one place


#function abort
function Abort {
  typeset exitcode=$1 ; shift
  case "$exitcode" in
    0 ) Log INFO "$*" ;;
    * ) Log FATAL "$*" ;;
  esac
  exit $exitcode
}

function Log {
  typeset level=$1 ; shift
  typeset msg="$*"
  typeset date="`date '+%Y/%m/%d %H:%M:%S'`"

  case "$level" in
    ERROR | FATAL        ) echo "$date $level: $msg" >&2 ;;
    WARN  | INFO | DEBUG ) echo "$date $level: $msg" ;;
    * ) Abort 1 "Internal error: invalid log level ($level)" ;;
  esac
}

##Creating ECR repository 
function create_ecr_repository() {
  local repository_name=$1
  local region=$2

  for images in ${imagesList[@]}; do
    
    imagenamewithtag=${images##*/}
    imagewithouttag="$( cut -d ':' -f 1 <<< "$imagenamewithtag" )";
    typeset rc=$?
    
    echo "Creating ECR repository region: $repository_name/$imagewithouttag"
    
    aws ecr create-repository --repository-name "$repository_name/$imagewithouttag" --region "$region"  --image-tag-mutability IMMUTABLE --image-scanning-configuration scanOnPush=true  &> /dev/null
    if [[ $rc -eq 0 ]]; then
      Log INFO "AWS ECR repo: $repository_name/$imagewithouttag on region: ${cloudRegion} created successfully"
    elif [[ $rc -eq 254 ]]; then
      Log WARN "AWS ECR repo: $repository_name/$imagewithouttag on region: ${cloudRegion} already exists"
    else
      Abort 255 "Failed to create AWS ECR repo: $repository_name/$imagewithouttag on region: ${cloudRegion}"
    fi
  
  done

}

# Function to login to ECR
function login_to_ecr() {
  local cloud_provider=$1
  local region=$2
  local login_password=$3
  local account_id=$4

  echo "Logging in to ECR..."
  echo "$login_password" | docker login --username AWS --password-stdin "$account_id".dkr.ecr."$region".amazonaws.com

  if [[ $? -eq 0 ]]; then
    Log INFO "AWS ecr login configured successfully for account id: ${account_id}"
  else
    Abort 255 "Failed to login AWS ECR account id: ${account_id}"
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
function ecr_fetch_push_images() {
    
    # Build ECR repository
    create_ecr_repository "$repoName" "$cloudRegion" 

    # Creds for ecr login
    ecrLogin=$(aws ecr get-login-password --region "$cloudRegion")

    # Login to the ecr
    login_to_ecr "$cloudProvider" "$cloudRegion" "$ecrLogin" "$accountId"

    for image in "${imagesList[@]}"; do
        #Dividing the names in different formats
        pull_image=$(echo "$image" | awk -F ':' '{print $1}' )
        echo ---------------------------
        echo $pull_image
        source_image=$(echo "$image" | awk -F '/' '{print $NF}' | awk -F ':' '{print $1}' )
        echo ---------------------------
        echo $source_image
        target_image="$accountId.dkr.ecr.$cloudRegion.amazonaws.com/$repoName/$source_image"
        echo ---------------------------
        echo $target_image
        tag=$(echo "$image" | awk -F ':' '{print $2}')
        echo ---------------------------
        echo $tag
        push_image_to_ecr "$pull_image" "$source_image" "$target_image" "$tag" 
    done
}

ecr_fetch_push_images