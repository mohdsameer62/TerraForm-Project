terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.6.0"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state-file-backend"
    key            = "network/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks-tf-state"
  }
}

provider "aws" {
    region = var.availability_zone
    profile = "aws-terraform-admin"
}