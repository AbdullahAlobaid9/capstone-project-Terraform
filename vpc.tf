resource "alicloud_vpc" "vpc" {
  description = "vpc"
  cidr_block  = "10.0.0.0/8"
  vpc_name    = "capstone-vpc"
}


data "alicloud_zones" "zone" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

resource "alicloud_vswitch" "public" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.1.0/24"
  zone_id      = data.alicloud_zones.zone.zones.0.id
  vswitch_name = "public"
}

resource "alicloud_vswitch" "public-b" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.3.0/24"
  zone_id      = data.alicloud_zones.zone.zones.1.id
  vswitch_name = "public"
}

resource "alicloud_vswitch" "private" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = "10.0.2.0/24"
  zone_id      = data.alicloud_zones.zone.zones.0.id
  vswitch_name = "private"
}


resource "alicloud_nat_gateway" "default" {
  vpc_id           = alicloud_vpc.vpc.id
  nat_gateway_name = "nat"   
  payment_type     = "PayAsYouGo"
  vswitch_id       = alicloud_vswitch.public.id
  nat_type         = "Enhanced"
}

resource "alicloud_eip_address" "nat" {
  description               = "Nat IP"
  address_name              = "nat"
  netmode                   = "public"
  bandwidth                 = "100"
  payment_type              = "PayAsYouGo"
  internet_charge_type      = "PayByTraffic"
  }

resource "alicloud_eip_association" "nat" {
  allocation_id = alicloud_eip_address.nat.id
  instance_id   = alicloud_nat_gateway.default.id
  instance_type = "Nat"
}


resource "alicloud_snat_entry" "private-ssh" {
  snat_table_id     = alicloud_nat_gateway.default.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private.id
  snat_ip           = alicloud_eip_address.nat.ip_address
}


resource "alicloud_route_table" "private" {
  description      = "private"
  vpc_id           = alicloud_vpc.vpc.id
  route_table_name = "private_route"
  associate_type   = "VSwitch"
}

resource "alicloud_route_entry" "private" {
  route_table_id        = alicloud_route_table.private.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.default.id
#   depends_on = [
#     alicloud_nat_gateway.default,
#     alicloud_route_table_attachment.private,
#     alicloud_snat_entry.private-ssh,
#     alicloud_eip_association.nat
# ]
}

resource "alicloud_route_table_attachment" "private" {
  vswitch_id     = alicloud_vswitch.private.id
  route_table_id = alicloud_route_table.private.id
}