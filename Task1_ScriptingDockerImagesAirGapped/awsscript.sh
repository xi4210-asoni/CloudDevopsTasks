#!/bin/bash

# YAML file to parse
yaml_file="/root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/awsdetails.yaml"

# Fetch parameters using yq
cloudProvider=$(yq eval '.cloudProvider' "$yaml_file")
cloudRegion=$(yq eval '.cloudRegion' "$yaml_file")
repoName=$(yq eval '.repoName' "$yaml_file")
imagesList=$(yq eval '.imagesList | join(", ")' "$yaml_file")

# Print the fetched parameters
echo "Cloud Provider: $cloudProvider"
echo "Cloud Region: $cloudRegion"
echo "Repository Name: $repoName"
echo "Images List: $imagesList"