resource "aws_lb_listener" "app" {
    certificate_arn   = var.certificate_arn
    load_balancer_arn = data.aws_lb.app.arn
    port              = 443
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"

    default_action {
        type             = "forward"
        forward {
            target_group {
                arn = data.aws_lb_target_group.blue_tg.arn
                weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
            }
            target_group {
                arn = data.aws_lb_target_group.green_tg.arn
                weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 100)
            }
            stickiness {
                enabled  = false
                duration = 1
            }

        }
        
        
    }

    timeouts {}
}
