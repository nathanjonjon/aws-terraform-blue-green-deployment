output green_info {
    value = {
        asg_name = aws_autoscaling_group.asg.name
        as_conf_name = aws_launch_configuration.as_conf.name
    }
}