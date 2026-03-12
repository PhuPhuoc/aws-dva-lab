resource "aws_lb" "web_alb" {
  name               = "d-lb-DVA-web-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  tags = {
    Name = "d-lb-DVA-web-alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
