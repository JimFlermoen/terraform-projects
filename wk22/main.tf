# root main.tf

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./resources"
  vpc_id = module.vpc.vpc_id
  name   = var.name
}
