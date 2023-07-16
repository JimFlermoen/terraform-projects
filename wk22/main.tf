# --Root main.tf--

module "vpc_resources" {
  source = "./resources"
  name   = var.name
  vpc_id = module.vpc_resources.vpc_id
}
