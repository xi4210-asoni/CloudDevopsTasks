#Creating Repository
resource "aws_ecr_repository" "ecr_creation" {
  name                 = var.reponame
  image_tag_mutability = var.mutability
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
  
  encryption_configuration {
    encryption_type = "KMS"       #defaults to AES-256
    kms_key = "arn:aws:kms:${var.regionname}:902324519920:key/64c4f09b-7324-4f15-9f83-0deb8e366bd2"
  }

}

#Adding Lifecycle Policy - For images to be deleted or removed after desired time interval
resource "aws_ecr_lifecycle_policy" "ecr_creation_lifecyclepolicy" {
  repository = aws_ecr_repository.ecr_creation.name
  policy     = jsonencode(var.image_expire_rules)
}

#Adding Repository Policy - For Adding the Repository policies in the repo created, Allowing few Accounts to Push Pull etc

resource "aws_ecr_repository_policy" "ecr_creation_repositorypolicy" {
  repository = aws_ecr_repository.ecr_creation.name
  policy     = jsonencode(var.repository_policy)
}

##!For Cross Region Replication

data "aws_caller_identity" "caller_id" {}

data "aws_regions" "region_details" {}

resource "aws_ecr_replication_configuration" "replication_configuration_rule" {
  replication_configuration {
    rule {
      destination {
        # region      = data.aws_regions.region_details.names[0]  #instead of fetch use the variable here
        region      = "us-east-2"
        registry_id = data.aws_caller_identity.caller_id.account_id   #fetch the account_id for aws user
      }

      repository_filter {
        filter      = var.reponame
        filter_type = "PREFIX_MATCH"
      }
    }
  }
}