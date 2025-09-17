terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Security Group: allow SSH + 3000 + 5000 + 8080 (for Jenkins)
resource "aws_security_group" "web" {
  name        = "ci-cd-sg"
  description = "Allow SSH, frontend, backend, Jenkins"

  ingress { from_port = 22   to_port = 22   protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 3000 to_port = 3000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 5000 to_port = 5000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 8080 to_port = 8080 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }

  egress  { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true
  filter { name = "name"   values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] }
  filter { name = "state"  values = ["available"] }
  filter { name = "root-device-type" values = ["ebs"] }
  filter { name = "virtualization-type" values = ["hvm"] }
}

resource "aws_instance" "vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = templatefile("${path.module}/user_data_single.tpl", { repo_url = var.repo_url })

  tags = { Name = "ci-cd-monorepo" }
}

output "public_ip" { value = aws_instance.vm.public_ip }
