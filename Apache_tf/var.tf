variable "vpccidr" {
  default = "10.0.0.0/16"
}
variable "privatesubnetcidr" {
  default = "10.0.1.0/24"
}
variable "publicsubnetcidr" {
  default = "10.0.2.0/24"
}
variable "securityip" {
  default = "203.170.48.2/32"
}
variable "AMI" {
  default = "ami-bf4193c7"
}
variable "keypair" {
  default = "tf-keypair"
}
