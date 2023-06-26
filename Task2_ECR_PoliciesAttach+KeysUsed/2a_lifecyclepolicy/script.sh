#!/bin/bash

REPONAME=testcrra 

# To create the repository and put lifecycle policy in it

aws ecr create-repository --repository-name testcrra  --region eu-north-1 --image-tag-mutability  IMMUTABLE --image-scanning-configuration scanOnPush=true  --encryption-configuration  encryptionType=KMS,kmsKey="arn:aws:kms:us-east-1:902324519920:key/64c4f09b-7324-4f15-9f83-0deb8e366bd2"


# Note - After the creation of AWS repository it is able to pull through it 

# lifecycle configuration will be added after the repo creation is done

aws ecr put-lifecycle-policy --repository-name testcrra --lifecycle-policy-text  file://2a_lifecyclepolicy/lifecycle_policies/lifecycle_rules.json

# set repository policy 

aws ecr set-repository-policy --repository-name testcrra  --policy-text file://2a_lifecyclepolicy/repository_policies/allow_oneormore_user.json