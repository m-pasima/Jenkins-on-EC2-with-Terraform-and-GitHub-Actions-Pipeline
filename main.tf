provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0b53285ea6c7a08a7" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = var.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "JenkinsServer"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.jenkins_server.public_ip} > ip_address.txt"
  }
}

output "instance_ip" {
  value = aws_instance.jenkins_server.public_ip
}
