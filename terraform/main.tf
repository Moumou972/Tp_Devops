terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

resource "aws_subnet" "private_subnet_moulanier_a" {
  # creates a subnet
  cidr_block        = "10.10.10.0/24"
  vpc_id            = var.vpc_a
  availability_zone = "eu-west-3a"
}


resource "aws_subnet" "private_subnet_moulanier_b" {
  # creates a subnet
  cidr_block        = "10.20.20.0/24"
  vpc_id            = var.vpc_b
  availability_zone = "eu-west-3a"
}

resource "aws_security_group" "security_group_moulanier_a" {
  name   = "allow-ssh-vpc_a"
  vpc_id = var.vpc_a

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
}


resource "aws_security_group" "security_group_moulanier_b" {
  name   = "allow-ssh-vpc-b"
  vpc_id = var.vpc_b

  ingress {
    cidr_blocks = [
      "10.0.0.0/16"
    ]

    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



resource "aws_instance" "instance_moulanier_a" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.type_instance
  key_name= var.key_ssh
 # security_groups = ["${aws_security_group.security_group_moulanier_a}"]
  subnet_id = aws_subnet.private_subnet_moulanier_a.id
  tags = {
    Name = "instance_moulanier_a"
    Created = "By Terraform"
  }
}

resource "aws_instance" "instance_moulanier_b" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.type_instance
  key_name= var.key_ssh
 # security_groups = ["${aws_security_group.security_group_moulanier_b}"]
  subnet_id = aws_subnet.private_subnet_moulanier_b.id
  tags = {
    Name = "instance_moulanier_b"
    Created = "By Terraform"
  }
}

resource "aws_instance" "instance_moulanier_c" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.type_instance
  key_name= var.key_ssh
  #security_groups = ["${aws_security_group.security_group_moulanier_b}"]
  subnet_id = aws_subnet.private_subnet_moulanier_b.id
  tags = {
    Name = "instance_moulanier_c"
    Created = "By Terraform"
  }
}

resource "aws_eip" "ip_instance_a"{
  vpc = true
  instance = aws_instance.instance_moulanier_a.id
}

resource "aws_eip" "ip_instance_b"{
  vpc = true
  instance = aws_instance.instance_moulanier_b.id
}

resource "aws_eip" "ip_instance_c"{
  vpc = true
  instance = aws_instance.instance_moulanier_c.id 
}

resource "aws_internet_gateway" "gw_instance_moulanier_a" {
  vpc_id = var.vpc_a
}

resource "aws_internet_gateway" "gw_instance_moulanier_b" {
  vpc_id = var.vpc_b
}

resource "aws_internet_gateway" "gw_instance_moulanier_c" {
  vpc_id = var.vpc_b
}
