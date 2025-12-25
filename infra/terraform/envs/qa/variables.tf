variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "env" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "azs" { type = list(string) }

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "repo_url" { type = string }
variable "git_ref" { type = string }
