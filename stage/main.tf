provider "aws" {
    region     = var.AWS_REGION
    max_retries = 2
}

## get ec2 config from existing launch template but feel free to customize the way you config your instance
data "aws_launch_template" "stageTemplate" {
  name = var.LAUNCH_TEMPLATE_NAME
}

resource "aws_instance" "autoStageEC2" {
  ami                     = data.aws_launch_template.stageTemplate.image_id
  instance_type           = "t2.micro"
  iam_instance_profile    = local.keys.IAM_ROLE
  vpc_security_group_ids = tolist(data.aws_launch_template.stageTemplate.network_interfaces[0]["security_groups"])
  tags = {Name = "stage-instance", Environment = "Stage"}
  key_name = var.key_name
  user_data = templatefile("./instance_config.sh", local.keys)
}


output "instance_id" {
  value = aws_instance.autoStageEC2.id
}

output "instance_public_ip" {
  value = aws_instance.autoStageEC2.public_ip 
}

output "instance_private_ip" {
  value = aws_instance.autoStageEC2.private_ip 
}

output "instance_public_dns" {
  value = aws_instance.autoStageEC2.public_dns
}

output "instance_private_dns" {
  value = aws_instance.autoStageEC2.private_dns
}

