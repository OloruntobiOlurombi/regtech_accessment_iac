# Provides a VPC resource
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.tags_vpc
  }
}


# Provides an VPC Public subnet resource
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.p_s_1_cidr_block
  availability_zone = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = var.tags_public_subnet_1
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.p_s_2_cidr_block
  availability_zone = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = var.tags_public_subnet_2
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.p_s_3_cidr_block
  availability_zone = var.az_c
  map_public_ip_on_launch = true

  tags = {
    Name = var.tags_public_subnet_3
  }
}

# Provides an VPC Private subnet resource
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_s_1_cidr_block
  availability_zone = var.az_private_a
  map_public_ip_on_launch = false 

  tags = {
    Name = var.tags_private_subnet_1
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_s_2_cidr_block
  availability_zone = var.az_private_b
  map_public_ip_on_launch = false 

  tags = {
    Name = var.tags_private_subnet_2
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_s_3_cidr_block
  availability_zone = var.az_private_c
  map_public_ip_on_launch = false 

  tags = {
    Name = var.tags_private_subnet_3
  }
}