module "ecr_genji_api" {
  source          = "./module/ecr"
  repository_name = var.repo_name
  tag_mutability  = "MUTABLE"
  scan_on_push    = true
}