resource "aws_security_group" "mysql" {
  name        = "mysql"
  description = "mysql"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "mysql"
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql_allow_bastion_ssh" {
  security_group_id = aws_security_group.mysql.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "mysql_allow_http_ssh" {
  security_group_id = aws_security_group.mysql.id
  referenced_security_group_id = aws_security_group.http.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_mysql" {
  security_group_id = aws_security_group.mysql.id
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
  referenced_security_group_id = aws_security_group.http.id
}

resource "aws_vpc_security_group_egress_rule" "allow_mysql_trafic" {
  security_group_id = aws_security_group.mysql.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
