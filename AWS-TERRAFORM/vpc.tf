resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "public-b"
  }
}

resource "aws_subnet" "private-b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "private-b"
  }
}

resource "aws_internet_gateway" "http-gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "http-gateway"
  }
}

resource "aws_route_table" "public-b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.http-gateway.id
  }

  tags = {
    Name = "public-b"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public-b.id
}

resource "aws_eip" "nat-ip" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.public-b.id

  tags = {
    Name = "gw-NAT"
  }

}

resource "aws_route_table" "private-b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "private-b"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.private-b.id
}

