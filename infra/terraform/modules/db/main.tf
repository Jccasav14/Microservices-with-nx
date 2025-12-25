terraform {
  required_providers { aws = { source="hashicorp/aws", version="~> 5.0" } }
}
data "aws_ami" "al2023" {
  most_recent = true
  owners=["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "db" {
  name = "${var.project_name}-${var.env}-db-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port=5432 to_port=5432 protocol="tcp"
    security_groups=[var.back_sg_id]
  }
  egress { from_port=0 to_port=0 protocol="-1" cidr_blocks=["0.0.0.0/0"] }
  tags = merge(var.tags,{Name="${var.project_name}-${var.env}-db-sg"})
}

resource "aws_instance" "db" {
  ami = data.aws_ami.al2023.id
  instance_type = var.instance_type
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.db.id]
  associate_public_ip_address = true

  user_data = base64encode(templatefile("${path.module}/templates/user_data_db.sh.tftpl", {}))
  tags = merge(var.tags,{Name="${var.project_name}-${var.env}-db"})
}

output "public_ip" { value = aws_instance.db.public_ip }
