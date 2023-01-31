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
resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.AZ.names)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.1.${1 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.AZ.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-sub"
  }
}


#create private1 subnet
resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.AZ.names)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.1.${2 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.AZ.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-sub"
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
resource "aws_route_table_association" "pub" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pub.id
}

#create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public-IGW"
  }
}