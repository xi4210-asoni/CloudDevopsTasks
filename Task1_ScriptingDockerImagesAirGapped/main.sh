#!/bin/bash

#VARIBLES
export YAML_FILE=""
export CLOUD_PROVIDER=""
export CLOUD_REGION=""
export REPONAME=""
export AWSACCOUNTID=""
# declare -x -A image_list=()               #map
declare -x -a IMAGE_LIST=()       #list

#Initializing modules
source /root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/modules/aws/fileparse/yaml_parser.sh
source /root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/modules/aws/errorhandling/error_handling.sh
source /root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/modules/aws/ecr/ecr_create.sh
source /root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/modules/aws/ecr/ecr_push.sh

#ConstVariables to provide
YAML_FILE="/root/work/CloudDevOpsTasks/Task1_ScriptingDockerImagesAirGapped/awsdetails.yaml"

#Getting the files from parse
parse_yaml_files "$YAML_FILE"
ecr_run