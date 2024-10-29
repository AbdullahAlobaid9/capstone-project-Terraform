resource "aws_instance" "mysql" {  
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private-b.id
  associate_public_ip_address = false
  key_name    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.mysql.id]
  user_data = base64encode(file("mysql-setup.sh"))
  tags = {
    Name = "mysql"
  }
}

output "mysql_private_ip" {
  value = aws_instance.mysql.private_ip
}