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


resource "aws_instance" "AnsibleManagedNode" {

  count = var.instance_count
  ami = data.aws_ami.ubuntu_22_04.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.AnsibleManagedNode.id]
  key_name = data.aws_key_pair.current.key_name
  tags = {
    Name = "AnsibleManagedNode-${count.index + 1}"
    Project = "AnsibleManagedNode"
    Owner = "yakymov1yevhen@gmail.com"
  }
  depends_on = [
    aws_key_pair.ansible
  ]
  user_data = file("user_data.sh")

}

variable "instance_count" {
  default = "3"
}

/*
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.AnsibleManagedNode.id
}
*/

resource "aws_security_group" "AnsibleManagedNode" {

  name        = "Ansible Managed Security Group"
  description = "Allow SSH inbound traffic"


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
    Name = "allow_ssh"
  }

}

resource "aws_key_pair" "ansible" {

  key_name = "ansible_managed_key"
  public_key = "your_public_key"

}


data "aws_key_pair" "current" {

  depends_on = [
    aws_key_pair.ansible
  ]

  key_name  = "ansible_managed_key"

}

/*
data "aws_instance" "current" {

  depends_on = [
    aws_instance.AnsibleManagedNode
  ]

  filter {
    name   = "tag:Name"
    values = ["AnsibleManagedNode*"]
  }

}

output "data_aws_instance_key_name" {
  value = data.aws_key_pair.current.key_name
}

output "data_aws_instance_public_ip" {

  value = data.aws_instance.current.public_ip
  
}

output "data_aws_instance_public_dns" {

  value = data.aws_instance.current.public_dns
  
}
*/
