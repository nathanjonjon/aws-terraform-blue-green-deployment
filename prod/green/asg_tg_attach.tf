resource "aws_autoscaling_attachment" "asg_attachment_alb_target_group" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  alb_target_group_arn   = var.green_tg_arn
}