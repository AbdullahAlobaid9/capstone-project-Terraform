
resource "alicloud_security_group" "redis-sg" {
  name        = "private_group"
  description = "New private_group"
  vpc_id = alicloud_vpc.vpc.id
}
resource "alicloud_security_group_rule" "allow_http_redis_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.redis-sg.id
  source_security_group_id = alicloud_security_group.http_group.id
}

resource "alicloud_security_group_rule" "allow_redis" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "6379/6379"
  priority          = 1
  security_group_id = alicloud_security_group.redis-sg.id
  source_security_group_id = alicloud_security_group.http_group.id
}

resource "alicloud_security_group_rule" "allow_bastion_to_redis" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = alicloud_security_group.redis-sg.id
  source_security_group_id = alicloud_security_group.bastion.id
}