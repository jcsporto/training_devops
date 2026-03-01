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
