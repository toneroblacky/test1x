# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr[terraform.workspace]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.tags, { Name = "bootcampvpc-${terraform.workspace}" })
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id             = aws_vpc.main.id
  cidr_block         = var.public_subnets[terraform.workspace]
  map_public_ip_on_launch = true
  availability_zone  = "${var.region}a"
  tags = merge(local.tags, { Name = "bootcamp-publicsub-${terraform.workspace}" })
}

resource "aws_subnet" "private" {
  vpc_id             = aws_vpc.main.id
  cidr_block         = var.private_subnets[terraform.workspace]
  map_public_ip_on_launch = false
  availability_zone  = "${var.region}b"
  tags = merge(local.tags, { Name = "bootcamp-privatesub-${terraform.workspace}" })
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.tags, { Name = "bootcamp-ig-${terraform.workspace}" })
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(local.tags, { Name = "bootcamp-rtpublic-${terraform.workspace}" })
}

# Route Table Association
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc" 
  tags = merge(local.tags, { Name = "bootcamp-nat-eip-${terraform.workspace}" })
}

# NAT Gateway for Private Subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = merge(local.tags, { Name = "bootcamp-natgw-${terraform.workspace}" })
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(local.tags, { Name = "bootcamp-rtprivate-${terraform.workspace}" })
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
