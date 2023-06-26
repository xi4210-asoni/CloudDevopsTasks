# TASK 2 ECR 

References: 
- Repository Policies
    - For Examples
        https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html
    - For Details
        https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policies.html
- LifeCycle Policies
    - For Details 
        https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html
    - For Examples
        https://docs.aws.amazon.com/AmazonECR/latest/userguide/lifecycle_policy_examples.html

- Encryption At rest
    - Blog
        https://aws.amazon.com/blogs/containers/configuring-kms-encryption-at-rest-on-ecr-repositories-with-ecr-replication/
        
        CloudFormation Template - https://github.com/aws-samples/amazon-ecr-kms-replication



### Errors Faced

- While putting the lifecycle rules in the repository

    An error occurred (InvalidParameterException) when calling the PutLifecyclePolicy operation: Invalid parameter at 'LifecyclePolicyText' failed to satisfy constraint: 'Lifecycle policy validation failure: Only one rule can select Untagged images.'

- Always provide a valid json else this will fail the cli command
