resource "digitalocean_droplet" "this" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "lon1"
  size   = "s-1vcpu-1gb"

  user_data = data.template_cloudinit_config.config.rendered
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.yml"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud-config.rendered
  }

  part {
    filename     = "bootstrap-vm"
    content_type = "text/x-shellscript"
    content      = data.template_file.bootstrap-vm.rendered
  }
}

data "template_file" "cloud-config" {
  template = file("${path.module}/scripts/init.yml")
  vars = {
    ssh_authorized_key = var.ssh_authorized_key
  }
}

data "template_file" "bootstrap-vm" {
  template = file("${path.module}/scripts/bootstrap-vm")
  vars = {
    image_tag = var.image_tag
  }
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
  value       = digitalocean_droplet.this.ipv4_address
  description = "The IPv4 address of the droplet"
}
