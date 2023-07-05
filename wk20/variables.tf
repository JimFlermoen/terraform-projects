# variables

variable "ami_id" {
  type    = string
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type    = string
  default = "subnet-048ec70282649b284"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0ee939e20d8876635"
}
