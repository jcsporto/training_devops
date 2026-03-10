resource "aws_autoscaling_group" "control_plane" {
  name                      = var.control_plane_auto_sacaling_group.name
  max_size                  = var.control_plane_auto_sacaling_group.max_size
  min_size                  = var.control_plane_auto_sacaling_group.min_size
  desired_capacity          = var.control_plane_auto_sacaling_group.desired_capacity
  health_check_grace_period = var.control_plane_auto_sacaling_group.health_check_grace_period
  health_check_type         = var.control_plane_auto_sacaling_group.health_check_type
  vpc_zone_identifier       = data.aws_subnets.private_subnets.ids

  launch_template {
    name    = aws_launch_template.control_plane.name
    version = "$latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = var.control_plane_auto_sacaling_group.instance_maintenance_policy.min_healthy_percent
    max_healthy_percentage = var.control_plane_auto_sacaling_group.instance_maintenance_policy.max_healthy_percent
  }

  tag {
    key                 = "Name"
    value               = var.tags.Project
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = var.tags.Environment
    propagate_at_launch = false
  }
}
