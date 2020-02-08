FROM alpine:latest

RUN apk update && \
    apk add php-fpm && \
    mkdir -p /run/php-fpm

COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY www.conf /etc/php7/php-fpm.d/www.conf

EXPOSE 9000

ENTRYPOINT [ "/usr/sbin/php-fpm7", "-R" ]