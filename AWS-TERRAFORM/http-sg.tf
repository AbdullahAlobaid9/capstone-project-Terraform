resource "aws_security_group" "http" {
  name        = "http"
  description = "http"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_allow_bastion_ssh" {
  security_group_id = aws_security_group.http.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_lb_nginx" {
  security_group_id = aws_security_group.http.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  referenced_security_group_id = aws_security_group.lb-sg.id
}

resource "aws_vpc_security_group_egress_rule" "allow_http_trafic" {
  security_group_id = aws_security_group.http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
