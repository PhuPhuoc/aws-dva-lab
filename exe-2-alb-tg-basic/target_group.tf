resource "aws_lb_target_group" "web_tg" {
  name     = "d-tg-DVA-web-server"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# aws_lb_target_group_attachment.web["web-server-1"]
# aws_lb_target_group_attachment.web["web-server-2"]
resource "aws_lb_target_group_attachment" "web" {
  for_each = aws_instance.web_server

  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = each.value.id
  port             = 80
}
