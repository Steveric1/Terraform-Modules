variable "vpc_cidr" {}
variable "project_name" {}
# variable "public1_cidr" {}
# variable "public2_cidr" {}
# variable "private1_cidr" {}
# variable "private2_cidr" {}

#security group varaible
variable "web_ingress" {
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr        = list(string)
  }))

  default = {
    "80" = {
      description = "HTTP traffic"
      port        = 80
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }

    "443" = {
      description = "HTTPS traffic"
      port        = 443
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }

    "22" = {
      description = "SSH traffic"
      port        = 22
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }
  }
}


#load balancer variables
variable "load_name" {
  type = string
}

variable "TG_name" {
  type = string
}

variable "port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "health_check" {
  type = map(string)
  default = {
    "interval"            = "300"
    "path"                = "/"
    "timeout"             = "60"
    "matcher"             = "200"
    "healthy_threshold"   = "5"
    "unhealthy_threshold" = "5"
  }
}

variable "port_listener" {
  type = string
}
variable "protocol_listener" {
  type = string
}

#route53 varaible
variable "domain_name" {
  type = string
}
variable "sub_domain_name" {
  type = string
}
