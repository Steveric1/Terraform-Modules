#create a vpc
module "vpc" {
  source       = "../modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

#Create security group
module "SG" {
  source = "../modules/SG"
  vpc_id = module.vpc.vpc_id
}

module "LB" {
  source            = "../modules/LB"
  load_name         = var.load_name
  TG_name           = var.TG_name
  port              = var.port
  protocol          = var.protocol
  port_listener     = var.port_listener
  protocol_listener = var.protocol_listener
  SG                = module.SG.SG
  pub1              = module.vpc.pub1
  pub2              = module.vpc.pub2
  vpc_id            = module.vpc.vpc_id
}

#provision an instance in aws console
resource "aws_instance" "web-server" {
  ami                         = "ami-00874d747dde814fa"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  key_name                    = "server"
  subnet_id                   = module.vpc.pub1
  associate_public_ip_address = true
  security_groups             = [module.SG.SG]

  provisioner "file" {
    source      = "script.sh"
    destination = "/home/ubuntu/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x script.sh",
      "sudo /home/ubuntu/script.sh args"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file("server.pem")
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> inventory"
  }

  tags = {
    Name = "web1"
  }
}

resource "aws_instance" "web-server2" {
  ami                         = "ami-00874d747dde814fa"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1b"
  key_name                    = "server"
  subnet_id                   = module.vpc.pub2
  associate_public_ip_address = true
  security_groups             = [module.SG.SG]

  provisioner "file" {
    source      = "script2.sh"
    destination = "/home/ubuntu/script2.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x script2.sh",
      "sudo /home/ubuntu/script2.sh args"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.web-server2.public_ip
    private_key = file("server.pem")
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> inventory"
  }

  tags = {
    Name = "web2"
  }
}

#Attached instances to the target group 
resource "aws_lb_target_group_attachment" "inst1" {
  target_group_arn = module.LB.target-group-arn
  target_id        = aws_instance.web-server.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "inst2" {
  target_group_arn = module.LB.target-group-arn
  target_id        = aws_instance.web-server2.id
  port             = 80
}

#create a route53 
module "route53" {
  source             = "../modules/route53"
  domain_name        = var.domain_name
  sub_domain_name    = var.sub_domain_name
  Application_LB_DNS = module.LB.Application_LB_DNS
  zone_id            = module.LB.zone_id
}