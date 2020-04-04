MAKEFILE ?= main.Makefile


deploy:
	docker run -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -v ${PWD}:/src cherwin/make deploy -f ${MAKEFILE}

custom-deploy:
	docker run -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -e IMAGE -e VERSION -v ${PWD}:/src cherwin/make deploy -f ${MAKEFILE}

test:
	docker run -t -v ${PWD}:/src cherwin/make test -f ${MAKEFILE}

clean:
	docker run -it -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -v ${PWD}:/src cherwin/make clean -f ${MAKEFILE}

# Below only works with dependencies installed locally
all:
	make all -f ${MAKEFILE}

shell:
	make shell -f ${MAKEFILE}

tail:
	make tail -f ${MAKEFILE}

watch:
	make watch -f ${MAKEFILE}
