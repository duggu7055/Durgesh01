terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }

  backend "s3" {
    bucket         = "demo-bucket-abcdefd12345"      
   key            = "terraform/state"
  region         = "ap-south-1"
  use_lockfile   = true
}
}

# Define the VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "igw"
  }
}

# Public Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# Associate Public Subnet with the Public Route Table
resource "aws_route_table_association" "pub_rt_asso" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat_eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat_gw"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_rt"
  }
}

# Associate Private Subnet with the Private Route Table
resource "aws_route_table_association" "private_rt_asso" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet.id
}

# Bastion Host EC2 Instance (Public Subnet)
resource "aws_instance" "bastion_host" {
  ami                         = "ami-023a307f3d27ea427" # Update to your region's AMI
  instance_type               = "t2.micro"
  key_name                    = "tool" # Ensure the key pair exists in AWS
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true # Public IP for SSH access

  tags = {
    Name = "bastion_host"
  }
}

# MySQL Server EC2 Instance (Private Subnet)
resource "aws_instance" "mysql_server" {
  ami                         = "ami-023a307f3d27ea427" # Update to your region's AMI
  instance_type               = "t2.micro"
  key_name                    = "tool" # Ensure the key pair exists in AWS
  subnet_id                   = aws_subnet.private_subnet.id
  vpc_security_group_ids      = [aws_security_group.mysql_sg.id]
  associate_public_ip_address = false # No public IP

  tags = {
    Name = "mysql_server"
  }

  # Copy Ansible Playbook
  provisioner "file" {
    source      = "playbook.yml"
    destination = "/home/ubuntu/playbook.yml"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      private_key         = file("./tool.pem")
      host                = self.private_ip # Use the private IP of the MySQL instance
      bastion_host        = aws_instance.bastion_host.public_ip # Connect via bastion host
      bastion_user        = "ubuntu"
      bastion_private_key = file("./tool.pem")
    }
  }

  # Execute Ansible Playbook
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt update -y",
      "sudo apt install -y ansible",
      "ansible-playbook /home/ubuntu/playbook.yml --connection=local"
    ]

    connection {
      type                = "ssh"
      user                = "ubuntu"
      private_key         = file("./tool.pem")
      host                = self.private_ip # Use the private IP of the MySQL instance
      bastion_host        = aws_instance.bastion_host.public_ip # Connect via bastion host
      bastion_user        = "ubuntu"
      bastion_private_key = file("./tool.pem")
    }
  }
}

