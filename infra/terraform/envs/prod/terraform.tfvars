aws_region   = "us-east-1"
project_name = "sibu"
env          = "prod"

tags = {
  Project = "sibu"
  Env     = "prod"
}

vpc_cidr = "10.20.0.0/16"
public_subnet_cidrs = ["10.20.1.0/24","10.20.2.0/24"]
azs = ["us-east-1a","us-east-1b"]

instance_type = "t3.micro"

# CHANGE_ME to your repo (recommended: public)
repo_url = "https://github.com/CHANGE_ME/CHANGE_ME"
git_ref  = "main"
