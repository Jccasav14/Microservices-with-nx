variable "project_name" { type=string }
variable "env" { type=string }
variable "vpc_id" { type=string }
variable "public_subnet_ids" { type=list(string) }
variable "back_sg_id" { type=string }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "tags" { type=map(string) default = {} }
