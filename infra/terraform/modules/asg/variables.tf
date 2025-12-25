variable "project_name" { type=string }
variable "env" { type=string }
variable "role" { type=string }
variable "aws_region" { type=string }
variable "ecr_registry" { type=string }
variable "vpc_id" { type=string }
variable "public_subnet_ids" { type=list(string) }
variable "alb_sg_id" { type=string }
variable "target_group_arn" { type=string }
variable "instance_type" { type=string default="t3.micro" }

variable "asg_min" { type=number default=1 }
variable "asg_desired" { type=number default=1 }
variable "asg_max" { type=number default=1 }

variable "web_image" { type=string default="" }
variable "auth_image" { type=string default="" }
variable "users_image" { type=string default="" }
variable "cases_image" { type=string default="" }
variable "db_host" { type=string default="" }

variable "tags" { type=map(string) default = {} }
