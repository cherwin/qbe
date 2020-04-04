# QBE Technical Test

### Preamble

This project creates a (self signed) HTTPS endpoint `/hello` which returns `world`.

##### How does this work?

We use Terraform to create a Virtual Machine in Digital Ocean. The VM gets provisioned with NGINX on top of docker via cloud-init. You will not be prompted for confirmation to apply the `terraform plan`.

---

### Prerequisites

To deploy you will only need `docker` and `make` installed locally. Any reasonably up to date version will probably do. See [Dependencies](#Dependencies) for the exact versions used in this project. I assume that you are using MacOS or Linux.

### Export Variables

Export your Personal Access Token and authorized key in order to run Terraform. I recommend [direnv](https://direnv.net/) to manage your exports.

    export DIGITALOCEAN_TOKEN="..."
    export SSH_AUTHORIZED_KEY="..."

See [How to Create a Personal Access Token](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/) and [Creating an SSH Key Pair for User Authentication](https://www.ssh.com/ssh/keygen/#creating-an-ssh-key-pair-for-user-authentication) for more information.

### Deploy

Deploy a VM provisoned with the pre-baked docker image `cherwin/qbe`.

    make deploy

### Deploy with custom docker image

Build and push IMAGE sourced from [nginx/Dockerfile](nginx/Dockerfile) before running below commands.

    export IMAGE=repo/tag
    export VERSION=0.1.0

    make custom-deploy

### Test

Test the endpoint.

    make test

### SSH to Virtual Machine

This command is for you convenience and only works with Terraform and SSH installed locally. I assume that you have `ssh-agent` configured correctly. Otherwise SSH manually.

    make shell

### Cleanup

Destroy the VM and remove the generated files. You will be prompted for confirmation.

    make clean

### Notes

This project is entirely driven by Makefile. I kindly suggest that you take a look at it to discover the convenience targets.

### Dependencies

This project has been tested with the following package versions.

* Docker 19.03.5
* GNU Make 4.2.1
* Terraform v0.12.24
* cURL 7.61.1
* OpenSSH_7.9p1
