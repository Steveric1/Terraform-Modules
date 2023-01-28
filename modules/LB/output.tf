output "Application_LB_DNS" {
  value = aws_lb.Application_LB.dns_name
}

output "target-group-arn"{
  value = aws_lb_target_group.target_G.arn
}

output "zone_id"{
  value = aws_lb.Application_LB.zone_id
}