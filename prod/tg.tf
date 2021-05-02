data "aws_lb_target_group" "green_tg" {
  name     = "app-tg-green"
}

data "aws_lb_target_group" "blue_tg" {
  name     = "app-tg-blue"
}