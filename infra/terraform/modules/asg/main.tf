terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "instance" {
  name   = "${var.project_name}-${var.env}-${var.role}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.project_name}-${var.env}-${var.role}-sg" })
}

locals {
  user_data = templatefile("${path.module}/templates/${var.role}_user_data.sh.tftpl", {
    repo_url = var.repo_url
    git_ref  = var.git_ref
    db_host  = var.db_host
  })
}

resource "aws_launch_template" "lt" {
  name_prefix            = "${var.project_name}-${var.env}-${var.role}-lt-"
  image_id               = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.project_name}-${var.env}-${var.role}" })
  }
}

resource "aws_autoscaling_group" "asg" {
  name             = "${var.project_name}-${var.env}-${var.role}-asg"
  min_size         = var.asg_min
  desired_capacity = var.asg_desired
  max_size         = var.asg_max

  vpc_zone_identifier = var.public_subnet_ids
  target_group_arns   = [var.target_group_arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "sg_id" {
  value = aws_security_group.instance.id
}
