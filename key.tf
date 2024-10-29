
resource "alicloud_ecs_key_pair" "ssh_key" {
  key_pair_name = "ssh_key3"
  key_file = "./ssh-key.pem"
}

