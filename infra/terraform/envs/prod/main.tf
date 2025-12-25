terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source="hashicorp/aws", version="~> 5.0" } }
}

provider "aws" {
  region = var.aws_region
}

locals {
  repo_web   = "${var.project_name}-web"
  repo_auth  = "${var.project_name}-auth"
  repo_users = "${var.project_name}-users"
  repo_cases = "${var.project_name}-cases"
}

module "ecr" {
  source     = "../../modules/ecr"
  repo_names = [local.repo_web, local.repo_auth, local.repo_users, local.repo_cases]
  tags       = var.tags
}

module "network" {
  source              = "../../modules/network"
  project_name        = var.project_name
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = var.azs
  tags                = var.tags
}

module "alb" {
  source            = "../../modules/alb"
  project_name      = var.project_name
  env               = var.env
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  tags              = var.tags
}

# Back ASG (usa DB host, depende de DB)
module "back_asg" {
  source            = "../../modules/asg"
  project_name      = var.project_name
  env               = var.env
  role              = "back"
  aws_region        = var.aws_region
  ecr_registry      = var.ecr_registry
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.alb.alb_sg_id
  target_group_arn  = module.alb.tg_back_arn
  instance_type     = var.instance_type

  asg_min = 1
  asg_desired = 1
  asg_max = 1

  auth_image  = var.auth_image
  users_image = var.users_image
  cases_image = var.cases_image

  db_host = module.db.public_ip
  tags = var.tags
}

module "db" {
  source            = "../../modules/db"
  project_name      = var.project_name
  env               = var.env
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  back_sg_id        = module.back_asg.sg_id
  instance_type     = var.instance_type
  tags              = var.tags
}

module "front_asg" {
  source            = "../../modules/asg"
  project_name      = var.project_name
  env               = var.env
  role              = "front"
  aws_region        = var.aws_region
  ecr_registry      = var.ecr_registry
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.alb.alb_sg_id
  target_group_arn  = module.alb.tg_front_arn
  instance_type     = var.instance_type

  asg_min = 1
  asg_desired = 1
  asg_max = 1

  web_image = var.web_image
  tags = var.tags
}

output "alb_dns_name" { value = module.alb.alb_dns_name }
output "ecr_repo_urls" { value = module.ecr.repo_urls }
