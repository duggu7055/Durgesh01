terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

provider "aws" {
  # Configuration options
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "ap-south-1"
}