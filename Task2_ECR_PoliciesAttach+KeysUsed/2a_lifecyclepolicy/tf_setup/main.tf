module "ecr" {
  source = "./modules/ecr"
  reponame = var.reponame
  regionname = var.regionname
}