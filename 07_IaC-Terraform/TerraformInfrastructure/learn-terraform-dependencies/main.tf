terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.44.0" 
    }
  }
}


provider "aws" {
    region = "eu-central-1"
}


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}


resource "aws_instance" "example_a" {
        ami = data.aws_ami.amazon_linux.id
        instance_type = "t2.micro"
}


resource "aws_instance" "example_b" {
        ami = data.aws_ami.amazon_linux.id
        instance_type = "t2.micro"
}


resource "aws_eip" "static_ip"{
  vpc = true
  instance = aws_instance.example_a.id
}


resource "aws_s3_bucket" "example" {
  acl = "private"
}

resource "aws_instance" "example_c" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  depends_on = [
    aws_s3_bucket.example
  ]
}


module "example_sqs_queue" {
  source = "terraform-aws-modules/sqs/aws"
  version = "2.1.0"

  depends_on = [
    aws_s3_bucket.example,
    aws_instance.example_c
  ]
}



/*
resource "aws_security_group" "MyWebServer-1" {
  name        = "Web Server Security Group"
  description = "Allow TCP inbound traffic"

  ingress {
    description      = "TCP from VPC (HTTP)"
    from_port        = 80 
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TCP from VPC HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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
*/