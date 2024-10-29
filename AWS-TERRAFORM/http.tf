resource "aws_instance" "web" {  
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private-b.id
  associate_public_ip_address = false
  key_name    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.http.id]
  user_data = base64encode(templatefile("http-setup.tpl",{redis_host=aws_instance.redis.private_ip, mysql_host=aws_instance.mysql.private_ip}))
  count = 2 
  tags = {
    Name = "private-http-${count.index}"
  }
}

output "web_private_ip" {
  value = aws_instance.web.*.private_ip
}