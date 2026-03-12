resource "aws_lb_target_group" "web_tg" {
  name     = "d-tg-dva-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}
