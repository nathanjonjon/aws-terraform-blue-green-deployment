resource "aws_launch_configuration" "as_conf" {
  name   = "${local.ec2_config.app_name}-launch_config"
  image_id      = local.ec2_config.ami_id
  instance_type = local.ec2_config.instance_type
  iam_instance_profile = local.input.IAM_ROLE
  security_groups = local.ec2_config.sg
  user_data = templatefile("./instance_config.sh", local.input)
  key_name = local.ec2_config.key_name
  lifecycle {
    create_before_destroy = true
  }
}