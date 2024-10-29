
resource "alicloud_security_group" "http_group" {
  name        = "security_group"
  description = "New security group"
  vpc_id = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "allow_bastion_to_http" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.http_group.id
  source_security_group_id = alicloud_security_group.bastion.id
}