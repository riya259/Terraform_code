provider "aws" {
region = "us-west-2"
 }
resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpccidr}"
  instance_tenancy = "default"
  tags = {
    Name = "VPC-tf"
    }
 }
resource "aws_subnet" "privatesubnet" {
	 vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.privatesubnetcidr}"
tags = {
    Name = "privatesubnet-tf"
  }
}
resource "aws_subnet" "publicsubnet" {
	 vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.publicsubnetcidr}"
tags = {
    Name = "publicsubnet-tf"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
tags = {
    Name = "igw"
  }
}
resource "aws_eip" "EIP" {
  vpc = true
}
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.EIP.id}"
  subnet_id = "${aws_subnet.publicsubnet.id}"
}
resource "aws_route_table" "pvt-rt" {
  vpc_id = "${aws_vpc.vpc.id}"
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }
tags = {
    Name = "pvt-rt-tf"
  }
}
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.vpc.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
 tags = {
    Name = "public-rt-tf"
  }
}
resource "aws_route_table_association" "pvt-rt-association" {
  subnet_id = "${aws_subnet.privatesubnet.id}"
  route_table_id = "${aws_route_table.pvt-rt.id}"
  }
resource "aws_route_table_association" "public-rt-association" {
  subnet_id = "${aws_subnet.publicsubnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}
resource "aws_network_acl" "NACL" {
  vpc_id = "${aws_vpc.vpc.id}"
egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "NACL-tf"
  }
}
resource "aws_security_group" "securitygroup" {
  name        = "securitygroup"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.vpc.id}"
ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.securityip}"]
  }
  ingress {
   from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpccidr}"]
	}
 egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "EC2instance" {
 ami = "${var.AMI}"
 instance_type = "t2.micro"
 subnet_id = "${aws_subnet.publicsubnet.id}"
 vpc_security_group_ids = ["${aws_security_group.securitygroup.id}"]
 key_name = "${var.keypair}"
 associate_public_ip_address = "true"
 tags = {
   Name = "tf-Ec2"
 }
}
