## Basic example

Creates a Virtual Machine in Digital Ocean. The VM gets provisioned with NGINX on top of docker via cloud-init.

```hcl
module "web" {
  source             = "./modules/web"
  image_tag          = "cherwin/qbe"
  ssh_authorized_key = "ssh-rsa AAAAB..."
}
```

### Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|image_tag|Docker image tag that will be run on the server|string|``|yes|
|ssh_authorized_key|SSH public key used to access droplet|string|``|yes|

### Outputs
| Name | Description |
|------|-------------|
|ipv4_address|The IPv4 address of the droplet|
