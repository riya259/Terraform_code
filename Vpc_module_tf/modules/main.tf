provider "aws" {
region = "us-west-2"
 }
resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
  tags = {
    Name = "vpc-tf"
    }
 }
