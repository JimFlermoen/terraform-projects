# Route Tables Child Module

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
  subnet_id      = aws_subnet.private_subnets["private_subnet_1"].id
  route_table_id = aws_route_table.private_rt.id
}

# Public route table associaction
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnets["public_subnet_1"].id
  route_table_id = aws_route_table.public_rt.id
}


output "private_rt_id" {
  value = aws_route_table.private_rt.id
}

output "public_rt_id" {
  value = aws_route_table.public_rt.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

