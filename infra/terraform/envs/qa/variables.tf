variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# registry base: <account>.dkr.ecr.<region>.amazonaws.com
variable "ecr_registry" {
  type = string
}

# full image refs with tags
variable "web_image" {
  type = string
}

variable "auth_image" {
  type = string
}

variable "users_image" {
  type = string
}

variable "cases_image" {
  type = string
}
