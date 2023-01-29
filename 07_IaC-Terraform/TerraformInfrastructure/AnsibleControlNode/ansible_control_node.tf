terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.44.0" 
    }
  }

}

provider "aws" {

  access_key = "your_access_key"
  secret_key = "your_secret_key"
  region = "your_region"

}


data "aws_ami" "ubuntu_22_04" {

  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

}


resource "aws_instance" "AnsibleController" {

  ami = data.aws_ami.ubuntu_22_04.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.AnsibleController.id]
  key_name = data.aws_key_pair.current.key_name
  tags = {
    Name = "AnsibleController"
    Project = "AnsibleControlNode"
    Owner = "yakymov1yevhen@gmail.com"
  }
  depends_on = [
    aws_key_pair.ansible
  ]
  user_data = file("user_data.sh")

}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.AnsibleController.id
}

resource "aws_security_group" "AnsibleController" {

  name        = "Ansible Security Group"
  description = "Allow TCP inbound traffic"

  dynamic "ingress" {
      for_each = ["80", "443"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }  
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tcp"
  }

}

resource "aws_key_pair" "ansible" {

  key_name = "ansible_key"
  public_key = "your_public_key"

}

data "aws_key_pair" "current" {

  depends_on = [
    aws_key_pair.ansible
  ]

  key_name  = "ansible_key"

}

data "aws_instance" "current" {

  depends_on = [
    aws_instance.AnsibleController,
    aws_eip.my_static_ip
  ]

  filter {
    name   = "tag:Name"
    values = ["AnsibleController"]
  }

}

output "name" {
  value = data.aws_key_pair.current.key_name
}

output "data_aws_instance_current" {

  value = data.aws_instance.current.public_ip
  
}

output "data_aws_instance_public_dns" {

  value = data.aws_instance.current.public_dns
  
}