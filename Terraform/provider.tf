terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
  
  backend "s3" {
    bucket         = "demo-bucket-abcdefd12345"
    key            = "terraform/state"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks" # Optional: Lock table for state locking
    encrypt        = true              # Optional: Encrypt the state file
  }
}

provider "aws" {
  # Configuration options
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "ap-south-1"
}
