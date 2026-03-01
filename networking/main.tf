terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-files-training-devops"
    key            = "networking/terraform.tfstate"
    region         = "us-east-1"
    profile        = "training_devops"
    dynamodb_table = "terraform-state-locking"
  }
}

provider "aws" {
  region  = var.region
  profile = "training_devops"

  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }
}

# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_vpc" "example2" {
#   cidr_block = "10.0.0.0/16"
# }