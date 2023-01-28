output "project_name" {
  value = var.project_name
}

output "vpc_id"{
  value = aws_vpc.my_vpc.id
}

output "pub1"{
  value = aws_subnet.public1.id
}

output "pub2"{
  value = aws_subnet.public2.id
}

output "priv1"{
  value = aws_subnet.private1.id
}

output "priv2"{
  value = aws_subnet.private2.id
}

output "route_table"{
  value = aws_route_table.pub.id
}

output "internet_gateway"{
  value = aws_internet_gateway.gw.id
}