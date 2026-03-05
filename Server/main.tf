terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-files-training-devops"
    key            = "server/terraform.tfstate"
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
