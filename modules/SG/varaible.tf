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

variable "vpc_id"{}