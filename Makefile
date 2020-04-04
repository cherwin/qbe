MAKEFILE ?= main.Makefile


deploy:
	docker run -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -v ${PWD}:/src cherwin/make -f ${MAKEFILE} deploy

custom-deploy:
	docker run -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -e IMAGE -e VERSION -v ${PWD}:/src cherwin/make -f ${MAKEFILE} deploy

test:
	docker run -t -v ${PWD}:/src cherwin/make test -f ${MAKEFILE}

clean:
	docker run -it -e DIGITALOCEAN_TOKEN -e SSH_AUTHORIZED_KEY -v ${PWD}:/src cherwin/make clean -f ${MAKEFILE}

# Below only works with dependencies installed locally
all:
	make -f ${MAKEFILE} all

shell:
	make -f ${MAKEFILE} shell

tail:
	make -f ${MAKEFILE} tail

watch:
	make -f ${MAKEFILE} watch
