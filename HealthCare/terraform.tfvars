#variable value declaration for vpc
vpc_cidr     = "10.1.0.0/16"
project_name = "HealthCare"
# public1_cidr  = "10.1.1.0/24"
# private1_cidr = "10.1.2.0/24"
# public2_cidr  = "10.1.3.0/24"
# private2_cidr = "10.1.4.0/24"

#variable value declaration for load balancer 
load_name         = "HealthCare"
TG_name           = "HealthCare"
port              = 80
protocol          = "HTTP"
port_listener     = "80"
protocol_listener = "HTTP"

#variable value declaration for route53
domain_name     = "steveric.me"
sub_domain_name = "www"

