# Launch Template
resource "aws_launch_template" "server_lt" {
  name_prefix   = "server-launch-template-of-Automate"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = var.security_group_ids
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "autoscaling-instance"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "server-asg" {
  name                      = "app-autoscaling-group-server"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.vpc_zone_identifier
  health_check_type         = "ELB"
  health_check_grace_period = 300
  force_delete              = true
  wait_for_capacity_timeout = "0"

  launch_template {
    id      = aws_launch_template.server_lt.id
    version = "$Latest"
  }

  # 👇 Register ASG with the ALB target group
  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "autoscaling-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}