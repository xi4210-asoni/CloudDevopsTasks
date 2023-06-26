output "RepositoryDetails" {
  value = {
    registry_id = aws_ecr_repository.ecr_creation.registry_id
    arn = aws_ecr_repository.ecr_creation.arn
  }
}