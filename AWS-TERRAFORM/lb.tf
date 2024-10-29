resource "aws_lb" "lb" {
    name               = "lb-http"
    load_balancer_type = "network"
    security_groups   = [aws_security_group.lb-sg.id]
    subnets = [aws_subnet.public-b.id]
    enable_deletion_protection = false
}

resource "aws_lb_target_group" "http-tg" {
  name     = "http-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval = 5
    timeout = 3
    protocol = "TCP"
  }
}

resource "aws_lb_target_group_attachment" "tg-attachment" {
  count= length(aws_instance.web)
  target_group_arn = aws_lb_target_group.http-tg.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http-tg.arn
  }
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}