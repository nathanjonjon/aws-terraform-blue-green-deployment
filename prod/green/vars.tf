variable "ECR_REPO" {
  type = string
}
variable "IAM_ROLE" {
  type = string
}
variable "AWS_REGION" {
  type = string
}
variable "key_name" {
    type = string
}

variable "VPC_ID" {
  type = string
}
data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

variable "LAUNCH_TEMPLATE_NAME" {
  type = string
}
data "aws_launch_template" "stageTemplate" {
  name = var.LAUNCH_TEMPLATE_NAME
}
locals {
  input = {
    ECR_REPO = var.ECR_REPO
    IAM_ROLE = var.IAM_ROLE
    ENV = "production"
    TAG = "latest"
  }
  ec2_config = {
      app_name = "web-server"
      instance_type = "t2.medium"
      ami_id = data.aws_launch_template.stageTemplate.image_id
      key_name = var.key_name
      sg = tolist(data.aws_launch_template.stageTemplate.network_interfaces[0]["security_groups"])
      subnets = data.aws_subnet_ids.subnets.ids
      vpc_id = var.VPC_ID
  }
}

variable "green_tg_arn" {}


resource "random_pet" "name_suffix" {}