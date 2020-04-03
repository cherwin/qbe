IMAGE ?= $(shell cat nginx/default/IMAGE)
VERSION ?= $(shell cat VERSION)

NGINX_KEY = nginx.key
NGINX_CRT = nginx.crt

TFSTATE = terraform/terraform.tfstate
IP = $(shell terraform output --state=${TFSTATE} ipv4_address)

TFPLAN = tfplan

SSH_USER = qbe


digitalocean_token_check:
	@[ -n "${DIGITALOCEAN_TOKEN}" ]

ssh_authorized_key_check:
	@[ -n "${SSH_AUTHORIZED_KEY}" ]

sanity_check: digitalocean_token_check ssh_authorized_key_check

certificates:
	mkdir -p nginx/certificates && \
	cd nginx/certificates && \
	openssl req \
		-x509 \
		-nodes \
		-days 365 \
		-newkey rsa:2048 \
		-keyout ${NGINX_KEY} \
		-out ${NGINX_CRT}

docker-build:
	cd nginx && \
	docker build \
		--tag ${IMAGE}:${VERSION} \
		--tag ${IMAGE}:latest \
		.

docker-push:
	cd nginx && \
	docker push ${IMAGE}:${VERSION} && \
	docker push ${IMAGE}:latest

terraform-plan: sanity_check
	cd terraform && \
	terraform init && \
	TF_VAR_image_tag=${IMAGE}:${VERSION} \
	TF_VAR_ssh_authorized_key="${SSH_AUTHORIZED_KEY}" \
	terraform plan \
		-out=${TFPLAN} \
		-input=false

terraform-apply: sanity_check
	cd terraform && \
	terraform init && \
	TF_VAR_image_tag=${IMAGE}:${VERSION} \
	TF_VAR_ssh_authorized_key="${SSH_AUTHORIZED_KEY}" \
	terraform apply \
		-input=false \
		-auto-approve \
		${TFPLAN}

terraform-destroy: sanity_check
	cd terraform && \
	terraform init && \
	TF_VAR_image_tag=${IMAGE}:${VERSION} \
	TF_VAR_ssh_authorized_key="${SSH_AUTHORIZED_KEY}" \
	terraform destroy

terraform-clean:
	cd terraform && \
	rm -f terraform.tfstate* && \
	rm -f ${TFPLAN} && \
	rm -rf .terraform

certificates-clean:
	cd nginx/certificates && \
	rm -f ${NGINX_KEY} && \
	rm -f ${NGINX_CRT}

# Convenience targets
deploy: terraform-plan terraform-apply

all: certificates docker-build docker-push terraform-plan terraform-apply

clean: terraform-destroy terraform-clean certificates-clean

# Debug targets
test:
	curl --insecure https://${IP}/hello

shell:
	ssh -oStrictHostKeyChecking=no ${SSH_USER}@${IP}

tail:
	ssh -oStrictHostKeyChecking=no ${SSH_USER}@${IP} tail -f /var/log/cloud-init-output.log

watch:
	ssh -t -oStrictHostKeyChecking=no ${SSH_USER}@${IP} sudo watch docker ps