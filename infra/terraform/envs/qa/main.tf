terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
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

module "db" {
  source            = "../../modules/db"
  project_name      = var.project_name
  env               = var.env
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  vpc_cidr          = var.vpc_cidr
  instance_type     = var.instance_type
  tags              = var.tags
}

module "back_asg" {
  source            = "../../modules/asg"
  project_name      = var.project_name
  env               = var.env
  role              = "back"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.alb.alb_sg_id
  target_group_arn  = module.alb.tg_back_arn
  instance_type     = var.instance_type

  asg_min     = 1
  asg_desired = 1
  asg_max     = 1

  repo_url = var.repo_url
  git_ref  = var.git_ref
  db_host  = module.db.private_ip

  tags = var.tags
}

module "front_asg" {
  source            = "../../modules/asg"
  project_name      = var.project_name
  env               = var.env
  role              = "front"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.alb.alb_sg_id
  target_group_arn  = module.alb.tg_front_arn
  instance_type     = var.instance_type

  asg_min     = 1
  asg_desired = 1
  asg_max     = 1

  repo_url = var.repo_url
  git_ref  = var.git_ref

  tags = var.tags
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
