# Subnets Child Module

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}
