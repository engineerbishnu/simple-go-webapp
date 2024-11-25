provider "aws" {
  region = "us-east-1"
}

# Security group to allow SSH, HTTP, and HTTPS traffic for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkinsSG"
  description = "Security group for Jenkins server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision EC2 instance for Jenkins
resource "aws_instance" "dev_ec2" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  key_name               = "Assessment-keypair"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "dev-jenkins-ec2"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e
              
              # Update package index
              sudo apt update -y
              
              # Install Java (required for Jenkins)
              sudo apt-get install fontconfig openjdk-17-jre -y
              
              # Add Jenkins repository key and repository
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update -y
              
              # Install Jenkins
              sudo apt-get install -y jenkins
              
              # Start Jenkins service
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              
              # Allow Jenkins on port 8080
              sudo ufw allow 8080
              sudo ufw reload
              
              # Output the initial Jenkins admin password
              echo "Jenkins installation complete! The initial admin password is:"
              sudo cat /var/lib/jenkins/secrets/initialAdminPassword
              EOF
}

output "public_ip" {
  description = "Public IP of the Jenkins EC2 instance"
  value       = aws_instance.dev_ec2.public_ip
}

output "keypair_name" {
  description = "The name of the SSH key pair used for the EC2 instance"
  value       = aws_instance.dev_ec2.key_name
}
