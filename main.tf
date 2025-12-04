terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_security_group" "basic_ssh" {
    name = "basic_ssh"
    description = "basic ssh security group"
    ingress {
        description = "basic ingress security group"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "basic egress security group"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "sshKey" {
    key_name = "sshKey"
    public_key = file("./sshKey.pub")
}

resource "aws_instance" "cicd_instance" {
    ami = "ami-0fa91bc90632c73c9"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.basic_ssh.id]
    key_name = aws_key_pair.sshKey.key_name
    user_data = <<-EOF
              #!/bin/bash
              # Update package lists
              sudo apt-get update -y

              # Install necessary packages for Docker
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

              # Add Docker's official GPG key
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

              # Add Docker repository
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

              # Update package lists again after adding Docker repository
              sudo apt-get update -y

              # Install Docker Engine
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io

              # Add the current user to the docker group to run Docker commands without sudo
              sudo usermod -aG docker ubuntu

              # Enable and start Docker service
              sudo systemctl enable docker
              sudo systemctl start docker
              EOF

    tags = {
        Name = "DockerInstance"
    }
}




output "ip_address" {
  value = aws_instance.cicd_instance.public_ip
}

