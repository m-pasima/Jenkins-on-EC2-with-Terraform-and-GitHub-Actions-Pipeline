provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main_route_table"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main_subnet"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_ssh_and_jenkins" {
  name        = "allow_ssh_and_jenkins"
  description = "Allow SSH and Jenkins traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
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

resource "aws_instance" "jenkins_server" {
  ami                     = "ami-0b53285ea6c7a08a7" # Amazon Linux 2 AMI
  instance_type           = "t2.micro"
  key_name                = var.key_name
  subnet_id               = aws_subnet.main.id
  vpc_security_group_ids  = [aws_security_group.allow_ssh_and_jenkins.id]
  associate_public_ip_address = true

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

