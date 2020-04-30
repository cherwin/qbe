FROM nginx:1.17.9-alpine

LABEL maintainer="Cherwin Nooitmeer <cherwin@gmail.com>"
LABEL repo.tag="cherwin/qbe"

COPY config/nginx.conf /etc/nginx/
COPY config/default.conf /etc/nginx/conf.d/

COPY certificates/nginx.crt /etc/ssl/
COPY certificates/nginx.key /etc/ssl/

RUN chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /etc/nginx && \
    mkdir -p /var/run/nginx && \
    chown nginx:nginx /var/run/nginx

USER nginx

EXPOSE 9443
