output "basion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "web_server_public_ip" {
  value = aws_instance.web_server.private_ip
}
