output "Webserver-Public-IP" {
  value = aws_instance.EC2instance.public_ip
}
