# VPC child Module

# Define the VPC 
resource "aws_vpc" "two-tier" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.name
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnets_cidr[0,1]
  availability_zone = var.availability_zones[0,1]

  tags = {
    Name = var.name
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnets_cidr[0,1]
  availability_zone = var.availability_zones[0,1]

  tags = {
    Name = var.name
  }
}
