resource "aws_instance" "bastion_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-b.id
  associate_public_ip_address = true
  key_name    = aws_key_pair.ssh_key.key_name
 vpc_security_group_ids = [aws_security_group.bastion.id]
  user_data = base64encode(file("bastion-setup.sh"))
  tags = {
    Name = "Bastion server -terraform"
  }
}
output "bastion_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}