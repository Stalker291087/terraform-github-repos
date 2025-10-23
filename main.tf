# --root/main.tf --
locals {
  enviroments = toset(["production", "development"])
}

module "repository" {
  source       = "./modules/dev-repos"
  repo-max     = var.repo-max
  env          = var.env
  github_token = var.github_token
  repositories = var.repositories
}