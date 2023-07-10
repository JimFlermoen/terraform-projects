# Innternet Gateway/Nat Gateway Child Module

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnets["private_subnet_1"].id

  tags = {
    Name = var.name
  }
}