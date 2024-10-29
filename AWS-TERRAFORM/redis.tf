resource "aws_instance" "redis" {  
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private-b.id
  associate_public_ip_address = false
  key_name    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.redis.id]
  user_data = base64encode(file("redis-setup.sh"))
  tags = {
    Name = "redis"
  }
}

output "redis_private_ip" {
  value = aws_instance.redis.private_ip
}