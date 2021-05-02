provider "aws" {
    region     = var.AWS_REGION
    max_retries = 2
}

module "green" {
  source = "./green"
  green_tg_arn = data.aws_lb_target_group.green_tg.arn
}

module "blue" {
  source = "./blue"
  blue_tg_arn = data.aws_lb_target_group.blue_tg.arn
}

output "green_infra_info" {
  value = module.green.green_info
}