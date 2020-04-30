FROM alpine:3.7

LABEL maintainer="Cherwin Nooitmeer <cherwin@gmail.com>"
LABEL repo.tag="cherwin/make"

COPY --from=hashicorp/terraform:0.12.24 /bin/terraform /bin/

RUN apk add --no-cache \
      ca-certificates \
      make \
      curl

RUN adduser -D -h /src cherwin

USER cherwin

WORKDIR /src

ENTRYPOINT ["make"]
