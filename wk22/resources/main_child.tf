# --VPC Resources Child Module--

#Retrieve the list of AZs
data "aws_availability_zones" "available" {}


# --VPC-- 
resource "aws_vpc" "wk22_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

# --Private Subnets--
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name = each.key
  }
}

# --Public Subnets--
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = var.name
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.name
  }
}

# Private route table associaction
resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private_rt.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

# Public route table associaction
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public_rt.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id

}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

# Create Elastic IP
resource "aws_eip" "wk22_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

# Create Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.wk22_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id

  tags = {
    Name = var.name
  }
}

