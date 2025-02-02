terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "mysubnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
}

resource "aws_route_table_association" "RTA" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "sg" {
  name   = "devops"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    description = "SSH access"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    description = "HTTP access"
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

resource "aws_key_pair" "keypair" {
  key_name   = "devops"
  public_key = file("~/.ssh/id_rsa.pub")
}



resource "aws_instance" "ec2" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.mysubnet1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source      = "./index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "remote_exec" {
    inline = [
      "echo 'Updating system...'",
      "sudo apt update -y",  # Update package list
      "sudo apt install -y nginx",  # Install Nginx
      "echo 'Copying index.html to the web server directory...'",
      "sudo mv /home/ubuntu/index.html /var/www/html/index.html",  # Move index.html to the correct location
      "echo 'Restarting Nginx...'",
      "sudo systemctl restart nginx",  # Restart Nginx to apply changes
      "sudo systemctl enable nginx",  # Ensure Nginx starts on boot
    ]
  }
}

