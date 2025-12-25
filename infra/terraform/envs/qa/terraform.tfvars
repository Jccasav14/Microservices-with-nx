aws_region   = "us-east-1"
project_name = "sibu"
env          = "qa"
tags = {
  Project = "sibu"
  Env     = "qa"
}

vpc_cidr = "10.10.0.0/16"
public_subnet_cidrs = ["10.10.1.0/24","10.10.2.0/24"]
azs = ["us-east-1a","us-east-1b"]

instance_type = "t3.micro"
