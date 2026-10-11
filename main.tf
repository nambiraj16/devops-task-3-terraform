terraform {
  required_version = ">= 1.0.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Pull official NGINX image
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

# Create and run the NGINX container
resource "docker_container" "nginx_server" {
  image = docker_image.nginx_image.image_id
  name  = "task3-nginx-webserver"

  ports {
    internal = 80
    external = 8081
  }
}

# Output the container ID
output "container_id" {
  description = "ID of the created Docker container"
  value       = docker_container.nginx_server.id
}

# Output the application URL
output "application_url" {
  description = "Access URL for the NGINX web server"
  value = "http://localhost:8081"
}
