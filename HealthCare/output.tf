output "public_ip1" {
  value = aws_instance.web-server.public_ip
}

output "public_ip2" {
  value = aws_instance.web-server2.public_ip
}

output "web-server" {
  value = aws_instance.web-server.id
}

output "web-server2" {
  value = aws_instance.web-server2.id
}