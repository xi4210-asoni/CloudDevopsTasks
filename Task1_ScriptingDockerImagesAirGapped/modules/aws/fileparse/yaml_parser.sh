#!/bin/bash


#Function to parse the yaml variables in files
function parse_yaml_files() {
    CLOUD_PROVIDER=$(yq eval '.cloud_provider' "$1")
    CLOUD_REGION=$(yq eval '.cloud_region' "$1") 
    REPONAME=$(yq eval '.ecr_repo_name' "$1")
    ECRCACHEREPONAME=$(yq eval '.ecr_cache_repo_name' "$1")
    ECRCACHEREPOUPSTREAM=$(yq eval '.ecr_cache_repo_upstream' "$1")
    AWSACCOUNTID=$(yq eval '.account_id' "$1")
    IMAGE_LIST=($(yq eval '.images_list[]' "$1")) 
}
