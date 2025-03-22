terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }

  backend "s3" {
    bucket = "nagham-terraform-bucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}