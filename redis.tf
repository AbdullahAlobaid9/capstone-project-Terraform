
resource "alicloud_instance" "redis" {
  availability_zone = data.alicloud_zones.zone.zones.0.id
  security_groups   = [alicloud_security_group.redis-sg.id]

  # series III
  instance_type              = "ecs.g6.large"
  system_disk_category       = "cloud_essd"
  image_id                   = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
  instance_name              = "redis"
  vswitch_id                 = alicloud_vswitch.private.id
  internet_max_bandwidth_out = 0
  instance_charge_type = "PostPaid"       
  key_name = alicloud_ecs_key_pair.ssh_key.key_pair_name
  user_data = base64encode(file("redis-setup.sh"))
}


output "redis" {
    value = alicloud_instance.redis.private_ip
}
