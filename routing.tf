# Provides a resource to create a VPC routing table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.tags_public_rt
  }
}

# Provides a resource to create an association between a route table and Public subnets
resource "aws_route_table_association" "public_subnet_1_association" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_rt.id 
}

resource "aws_route_table_association" "public_subnet_2_association" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_rt.id 
}

resource "aws_route_table_association" "public_subnet_3_association" {
    subnet_id = aws_subnet.public_subnet_3.id
    route_table_id = aws_route_table.public_rt.id 
}


# Provides a resource to create a VPC Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.tags_igw
  }
}

# Provides a resource to create a private route table 
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id

}

# Provides a resource to create an association between a route table and Private subnets
resource "aws_route_table_association" "private_subnet_1_association" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_rt.id 
}

resource "aws_route_table_association" "private_subnet_2_association" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.private_rt.id 
}

resource "aws_route_table_association" "private_subnet_3_association" {
    subnet_id = aws_subnet.private_subnet_3.id
    route_table_id = aws_route_table.private_rt.id 
}

