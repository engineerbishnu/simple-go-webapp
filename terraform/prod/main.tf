provider "aws" {
  region = "us-east-1"
}

# Security group to allow SSH and HTTP traffic for the production EC2 instance
resource "aws_security_group" "prod_sg" {
  name        = "prodSG"
  description = "Security group for production server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH access from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP access from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP access for Jenkins Web UI
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# Provision EC2 instance for production (prod-ec2)
resource "aws_instance" "prod_ec2" {
  ami                    = "ami-0866a3c8686eaeeba"  # Example Ubuntu AMI, change as needed
  instance_type          = "t2.medium"
  key_name               = "Assessment-keypair" # SSH key pair for access
  vpc_security_group_ids = [aws_security_group.prod_sg.id] # Security group attached

  tags = {
    Name = "prod-k8s-ec2"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update package index
              sudo apt update -y

              # Install Docker
              sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              sudo apt update -y
              sudo apt install -y docker-ce

              # Add user to Docker group
              sudo usermod -aG docker ubuntu
              sudo systemctl enable docker
              sudo systemctl start docker

              # Install kubectl
              curl -LO "https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl"
              chmod +x ./kubectl
              sudo mv ./kubectl /usr/local/bin/kubectl

              # Install Helm
              curl https://get.helm.sh/helm-v3.11.0-linux-amd64.tar.gz -o helm-v3.11.0-linux-amd64.tar.gz
              tar -zxvf helm-v3.11.0-linux-amd64.tar.gz
              sudo mv linux-amd64/helm /usr/local/bin/helm
              rm -rf linux-amd64 helm-v3.11.0-linux-amd64.tar.gz

              # Enable Helm completion for bash
              echo "source <(helm completion bash)" >> ~/.bashrc
              source ~/.bashrc

              # Install K3d (Lightweight Kubernetes Cluster on Docker)
              sudo curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

              # Install kubectl via snap
              sudo snap install kubectl --classic

              # Setting-up k3d cluster locally
              k3d cluster create prod-cluster --agents 2
              EOF
}

output "public_ip" {
  description = "Public IP of the production EC2 instance"
  value       = aws_instance.prod_ec2.public_ip
}

output "keypair_name" {
  description = "The name of the SSH key pair used for the EC2 instance"
  value       = aws_instance.prod_ec2.key_name
}
