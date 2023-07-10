# VPC child Module


# --Define the VPC-- 
resource "aws_vpc" "two-tier" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.name
  }
}




