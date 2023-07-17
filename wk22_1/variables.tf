# --Variables.tf-- 

variable "name" {
  default = "wk22-project"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ["public_subnet_1", "private_subnet_2"]
}

variable "public_subnets" {
  default = ["public_subnet_1", "public_subnet_2"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "Projectkey"
}

variable "username" {
  type      = string
  default   = "admin"
  sensitive = true
}

variable "passwd" {
  type      = string
  default   = "mysql_22"
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "my_db"
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.32"
}

variable "parameter_group_name" {
  type    = string
  default = "default.mysql5.7"
}

variable "allocated_storage" {
  type    = number
  default = 10
}

variable "max_allocated_storage" {
  type    = string
  default = 20
}

variable "publicly_accessible" {
  type    = string
  default = false
}

variable "skip_final_snapshot" {
  type    = string
  default = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "storage_type" {
  type    = string
  default = "gp2"
}
