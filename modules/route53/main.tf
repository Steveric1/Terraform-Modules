#create a route53 hosted zone
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

#create a record set inside the hosted zone created earlier
resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.sub_domain_name
  type    = "A"

  alias {
    name                   = var.Application_LB_DNS
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}
