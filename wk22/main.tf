# root main.tf

provider "aws" {
  region = var.aws_region
}

# --Create the VPC-- 
module "vpc" {
  source = "./resources"
  name   = var.name
  vpc_id = module.vpc.vpc_id
}
