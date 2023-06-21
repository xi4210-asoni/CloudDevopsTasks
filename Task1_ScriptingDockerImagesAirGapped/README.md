# TASK1 SCRIPTS FOR AWS, GCP, AZURE CONTAINER REGISTRY CREATION

## FILE STRUCTURE

### AWS
- modules/
    - aws/
        - ecr/
        - errorhandling/
        - fileparse/
    - gcp/
    - azure/

## SCRIPT DEPLOY

- Check the awsdetails.yaml and update the yaml with account-id, imagesname, cloudprovidername, ecrreponame, cachepullthrough reponame, etc

    [awsdetails.yaml](Task1_ScriptingDockerImagesAirGapped/awsdetails.yaml)
- Make all scripts executable before running the main.sh files
- AWS
    ```bash
        cd Task1_ScriptingDockerImagesAirGapped/
        ./main.sh
        // ./main.sh  "awsdetails.yaml"   //for reference only
    ```


## ECR CACHE PULL THROUGH

Monitors the upstream public repositories - k8s.gcr.io, public.ecr.aws etc.
Can pull through the updated images available from the communities in the cache repo 
Working

## KANIKO DEPLOYMENTS

kaniko build image - reference - https://github.com/GoogleContainerTools/kaniko#demo
