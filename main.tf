provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0b53285ea6c7a08a7" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = var.key_name

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
