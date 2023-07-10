# Child Module Variables

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type    = string
  default = "wk22-two-tier"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_id" {
  description = "gives the VPC Id"
}

variable "private_subnets" {
  type = map(any)
  default = {
    private_subnet_1 = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    }
    private_subnet_2 = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
    }
  }
}

variable "public_subnets" {
  type = map(any)
  default = {
    public_subnet_1 = {
      cidr = "10.0.100.0/24"
      az   = "us-east-1a"
    }
    public_subnet_2 = {
      cidr = "10.0.200.0/24"
      az   = "us-east-1b"
    }
  }
}