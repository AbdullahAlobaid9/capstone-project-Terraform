resource "aws_security_group" "redis" {
  name        = "redis"
  description = "redis"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "redis"
  }
}

resource "aws_vpc_security_group_ingress_rule" "redis_allow_bastion_ssh" {
  security_group_id = aws_security_group.redis.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "redis_allow_http_ssh" {
  security_group_id = aws_security_group.redis.id
  referenced_security_group_id = aws_security_group.http.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_redis" {
  security_group_id = aws_security_group.redis.id
  from_port         = 6379
  ip_protocol       = "tcp"
  to_port           = 6379
  referenced_security_group_id = aws_security_group.http.id
}

resource "aws_vpc_security_group_egress_rule" "allow_redis_trafic" {
  security_group_id = aws_security_group.redis.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
