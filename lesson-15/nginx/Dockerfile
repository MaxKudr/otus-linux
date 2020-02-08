FROM alpine:latest

RUN apk update && \
    apk add nginx && \
    mkdir /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY php.conf /etc/nginx/php.conf
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/nginx" ]