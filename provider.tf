terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.6.0"
    }
  }
}

provider "aws" {
    region = var.availability_zone
    profile = "aws-terraform-admin"
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-file-backend-2027"
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks-tf-state"  
    encrypt        = true
  }
}
