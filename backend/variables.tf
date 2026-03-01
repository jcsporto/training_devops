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
    state_locking = object({
      dynamodb_table_name          = string
      dynamodb_table_billing_mode  = string
      dynamodb_table_hash_key      = string
      dynamodb_table_hash_key_type = string
    })
  })

  description = "S3 bucket and DynamoDB table for remote state storage and locking"
  # Define valores no arquivo terraform.tfvars (não versionado)
}
