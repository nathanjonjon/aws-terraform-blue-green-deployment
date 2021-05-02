resource "aws_autoscaling_group" "asg" {
  name          = "${local.ec2_config.app_name}-asg"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 1
  desired_capacity     = 1
  max_size             = 3
  vpc_zone_identifier = local.ec2_config.subnets
  health_check_grace_period = 300
  health_check_type = "ELB"
  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "autoscaling-prod-instance"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "env"
        "value"               = "prod"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "app"
        "value"               = "web-server"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "color"
        "value"               = "blue"
        "propagate_at_launch" = true
      },
    ],
  )
  lifecycle {
    create_before_destroy = true
  }
}
