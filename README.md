# QBE Technical Test

### Preamble

This project creates a (self signed) HTTPS endpoint `/hello` which returns `world`.

##### How does this work?

We use Terraform to create a Virtual Machine in Digital Ocean. The VM gets provisioned with NGINX on top of docker via cloud-init. You will not be prompted for confirmation to apply the `terraform plan`.

---
### Export Variables

Export your Personal Access Token and authorized key in order to run Terraform. I recommend [direnv](https://direnv.net/) to manage your exports.

    export DIGITALOCEAN_TOKEN="..."
    export SSH_AUTHORIZED_KEY="..."

See [How to Create a Personal Access Token](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/) for more information.

### Deploy

Deploy a VM provisoned with the pre-baked docker image `cherwin/qbe`.

    docker run -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -v ${PWD}:/src cherwin/make deploy

### Deploy with custom docker image

Build and push IMAGE sourced from [nginx/Dockerfile](nginx/Dockerfile) before running below commands.

    export IMAGE=repo/tag
    export VERSION=0.1.0

    docker run -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -e IMAGE -e VERSION -v ${PWD}:/src cherwin/make deploy


### SSH to Virtual Machine

    make shell

You might have to wait a little while for the daemon to come up.

### Test

Test the endpoint.

    docker run -t -v ${PWD}:/src cherwin/make test

### Cleanup

Destroy the VM and remove the generated files. You will be prompted for confirmation.

    docker run -it -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -v ${PWD}:/src cherwin/make clean

### Notes

This project is entirely driven by Makefile. I kindly suggest that you take a look at it to discover the convenience targets.

### Dependencies

This project has been tested with the following package versions.

* Docker 19.03.5
* GNU Make 4.2.1
* Terraform v0.12.24
* cURL 7.61.1
