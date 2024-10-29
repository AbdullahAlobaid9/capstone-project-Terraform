resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "bastion"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_bastion_ssh" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_bastion_trafic" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

