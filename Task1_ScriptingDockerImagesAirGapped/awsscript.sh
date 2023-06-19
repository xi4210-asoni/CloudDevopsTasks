#!/bin/bash

yaml_file="/root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/awsdetails.yaml"

# Fetch parameters using yq
cloudProvider=$(yq eval '.cloudProvider' "$yaml_file")
cloudRegion=$(yq eval '.cloudRegion' "$yaml_file")
repoName=$(yq eval '.ecrRepoName' "$yaml_file")
accountId=$(yq eval '.accountId' "$yaml_file")
imagesList=($(yq eval '.imagesList[]' "$yaml_file"))

##Creating ECR repository 
create_ecr_repository() {
  local repository_name=$1
  local region=$2

  echo "Creating ECR repository, region: $repository_name $region"
  aws ecr create-repository --repository-name "$repository_name" --region "$region"
}

# Function to login to ECR
login_to_ecr() {
  local cloud_provider=$1
  local region=$2
  local login_password=$3
  local account_id=$4

  echo "Logging in to ECR..."
  echo "$login_password" | docker login --username AWS --password-stdin "$account_id".dkr.ecr."$region".amazonaws.com
}


# Function to push image to ECR
push_image_to_ecr() {
  local source_image=$1
  local target_image=$2
  local tag=$3

  echo "Pushing image: $target_image:$tag"
  docker pull "$source_image"
  docker tag "$source_image" "$target_image:$tag"
  docker push "$target_image:$tag"
}

## ECR push images
ecr_fetch_push_images() {
    
    # Build ECR repository
    create_ecr_repository "$repoName" "$cloudRegion"

    # Creds for ecr login
    ecrLogin=$(aws ecr get-login-password --region "$cloudRegion")

    # # Login to the ecr
    login_to_ecr "$cloudProvider" "$cloudRegion" "$ecrLogin" "$accountId"

    echo "Pushing images to ECR..."
    for image in "${imagesList[@]}"; do
        source_image=$(echo "$image" | awk -F ':' '{print $1}')
        echo $source_image
        target_image="$accountId.dkr.ecr.$cloudRegion.amazonaws.com/$repoName-$(echo "$image" | awk -F ':' '{print $1}' | awk -F '/' '{print $NF}')"
        echo $target_image
        tag=$(echo "$image" | awk -F ':' '{print $2}')

        push_image_to_ecr "$source_image" "$target_image" "$tag"
    done

    # echo "ECR build and image push completed."
}

# ecr_fetch_push_images
registry="902324519920.dkr.ecr.ap-south-1.amazonaws.com"
awsregion="ap-south-1"

echo $registry

for oldimage in "${imagesList[@]}"
  do

    # spliting on basis of '/' and get the last element of image
    imagenamewithtag=${oldimage##*/}
    newimage="$registry/$imagenamewithtag";

    newimagename="$( cut -d ':' -f 1 <<< "$imagenamewithtag" )";

    echo $newimage
    docker tag $oldimage $newimage
    echo "Image info imagename:$imagenamewithtag"

    echo $newimagename

    aws ecr describe-repositories --region ${awsregion} --repository-names $newimagename || aws ecr create-repository --repository-name $newimagename --region ${awsregion}
    docker push $newimage
  done