#creating a vpc 
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#use data source to get all availability zone in region
data "aws_availability_zones" "AZ" {}

#create a public subnet inside in the vpc
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public1_cidr
  availability_zone       = data.aws_availability_zones.AZ.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-sub"
  }
}

#create a public2 subnet inside vpc
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public2_cidr
  availability_zone       = data.aws_availability_zones.AZ.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public2-sub"
  }
}

#create private1 subnet
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private1_cidr
  availability_zone       = data.aws_availability_zones.AZ.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "private1-sub"
  }
}

#create private2 subnet
resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private2_cidr
  availability_zone       = data.aws_availability_zones.AZ.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private2-sub"
  }
}

#create a route table 
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route"
  }
}

#create a subnet association to seperate my public subnet from private subnet
resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.pub.id
}

#create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public-IGW"
  }
}