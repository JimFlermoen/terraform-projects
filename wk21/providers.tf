# Providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "jf-tf-backend07423"
    key    = "week-21/backend"
    region = "us-east-1"
  }
}