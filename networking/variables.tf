variable "region" {
  default = "us-east-1"
}

variable "assume_role" {
  type = object({
    role_arn    = string
    external_id = string
  })
  description = "AWS IAM role to assume with external ID"
  # Define valores no arquivo terraform.tfvars (não versionado)
}

variable "vpc" {
  
  type = object({
    name = string
    cidr_block = string
    internet_gateway_name = string
  })

  default = {
    name = "training-devops-vpc"
    cidr_block = "10.0.0.0/24"
    internet_gateway_name = "internet-gateway"
  }
}