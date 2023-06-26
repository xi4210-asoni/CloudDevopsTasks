variable "reponame" {}
variable "regionname" {}

variable "mutability" {
  type    = string
  default = "IMMUTABLE"
}

variable "image_expire_rules" {
  default = {
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep only one untagged image, expire all others",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
  }
}

variable "repository_policy" {
  default = {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowPushPull",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::902324519920:user/derek",
            "arn:aws:iam::902324519920:user/diego",
            "arn:aws:iam::902324519920:user/ragnar",
            "arn:aws:iam::902324519920:user/scott"
          ]
        },
        "Action": [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
}
