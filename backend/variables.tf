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

variable "tags" {
  type = map(string)
  default = {
    Project     = "not-so-simple-ecommerce"
    Environment = "production"
  }
}


variable "remote_backend" {
  type = object({
    bucket = string
  })
  description = "S3 bucket for remote state storage"
  # Define valores no arquivo terraform.tfvars (não versionado)
}