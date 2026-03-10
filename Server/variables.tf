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
    key_pair_name      = string
    instance_profile   = string
    instance_role      = string
    ssh_security_group = string
    ssh_source_ip      = string
  })

  default = {
    key_pair_name      = "training-devops-key-pair"
    instance_role      = "training-devops-instance-role"
    instance_profile   = "training-devops-instance-profile"
    ssh_security_group = "allow-ssh"
    ssh_source_ip      = "189.84.221.96/32"
  }
}



variable "vpc_resources" {
  type = object({
    vpc = string
  })

  default = {
    vpc = "training-devops-vpc"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "control_plane_launch_template" {
  type = object({
    name                                 = string
    disable_api_stop                     = bool
    disable_api_termination              = bool
    instance_type                        = string
    instance_initiated_shutdown_behavior = string
    ebs = object({
      size                  = number
      delete_on_termination = bool
    })
  })

  default = {
    name                                 = "training-devops-debian-control-plane-lt"
    disable_api_stop                     = true
    disable_api_termination              = true
    instance_type                        = "t3.micro"
    instance_initiated_shutdown_behavior = "terminate"

    ebs = {
      size                  = 20
      delete_on_termination = false
    }
  }
}

variable "control_plane_auto_sacaling_group" {
  type = object({
    name                      = string
    min_size                  = number
    max_size                  = number
    desired_capacity          = number
    health_check_grace_period = number
    health_check_type         = string
    instance_maintenance_policy = object({
      min_healthy_percent = number
      max_healthy_percent = number
    })
  })

  default = {
    name                      = "training_devops-control-plane-asg"
    max_size                  = 1
    min_size                  = 1
    desired_capacity          = 1
    health_check_grace_period = 180
    health_check_type         = "EC2"
    instance_maintenance_policy = {
      min_healthy_percent = 100
      max_healthy_percent = 110
    }
  }
}

