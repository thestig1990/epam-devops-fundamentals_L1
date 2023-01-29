provider "aws" {
    access_key = "your_access_key"
    secret_key = "your_secret_key"
    region = "your_aws_region"
}

resource "aws_instance" "MyWebServer-1" {
        count = 1
        ami = "ami-076309742d466ad69"
        instance_type = "t2.micro"
        vpc_security_group_ids = [aws_security_group.MyWebServer-1.id]
        tags = {
        Name = "MyWebServer-1"
        Project = "MyFirstInfrastructure"
        Owner = "yakymov1yevhen@gmail.com"
        }
        user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip = `curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform" > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
EOF
}

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