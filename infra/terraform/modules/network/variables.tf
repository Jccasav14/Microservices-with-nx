variable "project_name" { type = string }
variable "env" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "azs" { type = list(string) }

variable "tags" {
  type    = map(string)
  default = {}
}
