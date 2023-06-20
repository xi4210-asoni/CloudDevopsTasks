#!/bin/bash

yaml_file="/root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/awsdetails.yaml"

# Fetch parameters using yq
cloudProvider=$(yq eval '.cloudProvider' "$yaml_file")
cloudRegion=$(yq eval '.cloudRegion' "$yaml_file")
repoName=$(yq eval '.ecrRepoName' "$yaml_file")
accountId=$(yq eval '.accountId' "$yaml_file")
imagesList=($(yq eval '.imagesList[]' "$yaml_file"))    #Use this to fetch all the images into one place


function mod1() {
    echo 'calling mod1'
    echo $1
}