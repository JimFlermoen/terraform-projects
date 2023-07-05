variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type    = string
  default = "week-21-project"
}

variable "ami_id" {
  type    = string
  default = "ami-06b09bfacae1453cb"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "Projectkey"
}

variable "availability_zones" {
  type    = list(string)
  default = (["us-east-1a", "us-east-1b"])
}

variable "vpc_id" {
  type    = string
  default = "vpc-0ee939e20d8876635"
}

variable "bucket_name" {
  type    = string
  default = "jf-tf-backend07423"
}
