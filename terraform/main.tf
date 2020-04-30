terraform {
  required_version = "0.12.24"
}

provider "digitalocean" {
  version = "= 1.15.1"
}

provider "template" {
  version = "= 2.1.2"
}

module "web" {
  source             = "./modules/web"
  image_tag          = var.image_tag
  ssh_authorized_key = var.ssh_authorized_key
}

variable "image_tag" {
  type        = string
  description = "Docker image tag that will be run on the server"
}

variable "ssh_authorized_key" {
  type        = string
  description = "SSH public key used to access droplet"
}

output "ipv4_address" {
  value       = module.web.ipv4_address
  description = "The IPv4 address of the droplet"
}
