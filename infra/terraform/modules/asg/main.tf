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

  tags = merge(
    var.tags,
    { Name = "${var.project_name}-${var.env}-${var.role}-sg" }
  )
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.env}-${var.role}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}-${var.env}-${var.role}-profile"
  role = aws_iam_role.ec2_role.name
}

locals {
  user_data = templatefile("${path.module}/templates/${var.role}_user_data.sh.tftpl", {
    aws_region   = var.aws_region
    ecr_registry = var.ecr_registry
    web_image    = var.web_image
    auth_image   = var.auth_image
    users_image  = var.users_image
    cases_image  = var.cases_image
    db_host      = var.db_host
  })
}

resource "aws_launch_template" "lt" {
  name_prefix            = "${var.project_name}-${var.env}-${var.role}-lt-"
  image_id               = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = base64encode(local.user_data)

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

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
