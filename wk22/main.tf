# --Root main.tf--

module "vpc_resources" {
  source = "./resources"
  name   = var.name
  vpc_id = module.vpc_resources.vpc_id
}

module "webserver_1" {
  source         = "./resources"
  vpc_id         = module.vpc_resources.vpc_id
  public_subnets = aws_subnet.public_subnets.public_subnet_1.id
}

module "webserver_2" {
  source         = "./resources"
  vpc_id         = module.vpc_resources.vpc_id
  public_subnets = aws_subnet.public_subnets.public_subnet_2.id
}

module "rds" {
  source = "./resources"
  vpc_id = module.vpc_resources.vpc_id
}