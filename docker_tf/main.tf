resource "docker_image" "httpd_image" {
  name = "${var.image_name}"
}

resource "docker_container" "httpd_cont" {
  name  = "httpd_container"
  image = "${docker_image.httpd_image.latest}"
  ports {
    internal = "${var.internal_port}"
    external = "${var.external_port}"
  }
}

