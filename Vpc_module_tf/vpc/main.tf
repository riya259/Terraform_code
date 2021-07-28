provider "aws" {
  region = "us-west-2"
}

module "aws_vpc" {
  source = "../modules/"
  vpc_cidr  = "${var.vpc_cidr}"
}
