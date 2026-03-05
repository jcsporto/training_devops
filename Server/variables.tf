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


variable "ec2_resources" {
  type = object({
    key_pair_name    = string
    instance_profile = string
    instance_role    = string
  })

  default = {
    key_pair_name    = "training-devops-key-pair"
    instance_role    = "training-devops-instance-role"
    instance_profile = "training-devops-instance-profile"
  }
}
