output "IP Address" {
  value = "${docker_container.httpd_cont.ip_address}"
}

output "container_name" {
  value = "${docker_container.httpd_cont.name}"
}
