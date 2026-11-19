provider "aws" {
  region = "ap-south-1"
}

# Get the latest Ubuntu 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create Security Group
resource "aws_security_group" "devops_sg" {
  name        = "devops-project-sg"
  description = "Security group for DevOps project EC2"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Jenkins UI from my IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["223.178.83.180/32"]
  }

  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["223.178.83.180/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOps-Project-SG"
  }
}

# Create EC2 Instance
resource "aws_instance" "devops_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "devops-project-key"
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "DevOps-Monitoring-Server"
  }
}

# Output public IP
output "ec2_public_ip" {
  value = aws_instance.devops_server.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.devops_server.id
}