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

https://aws.amazon.com/blogs/containers/announcing-pull-through-cache-for-registry-k8s-io-in-amazon-elastic-container-registry/



## ECR CACHE PULL THROUGH

Monitors the upstream public repositories - k8s.gcr.io, public.ecr.aws etc.
Can pull through the updated images available from the communities in the cache repo 

A pull through cache is a way to cache images you use from an upstream repository. Container images are copied and kept up-to-date without giving you a direct dependency on the external registry. If the upstream registry or container image becomes unavailable, then your cached copy can still be used.

A pull through cache is an automatic way to store images in a new repository, when they are requested. The pull through cache automatically creates the image repository in your registry when it’s first requested and keeps the image updated and available for future pulls. You aren’t required to manually identify upstream dependencies or manually sync images when updating your images.

Working


## KANIKO DEPLOYMENTS

kaniko build image - reference - https://github.com/GoogleContainerTools/kaniko#demo
