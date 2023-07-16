# --VPC Resources Variables Child Module-- 

variable "name" {
  default = "wk22-two-tier"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "gives the VPC Id"
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
  }
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
  }
}