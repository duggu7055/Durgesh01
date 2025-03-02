output "aws_instance_public_ip" {
  value = aws_instance.bastion_host.public_ip
}
output "aws_instance_private_ip" {
  value = aws_instance.mysql_server.private_ip
}