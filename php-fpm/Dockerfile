#
#
#

ARG PHP_FPM_VERSION
FROM php:${PHP_FPM_VERSION}-fpm-alpine

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

ARG PHP_FPM_VERSION

RUN set -xe \
    && apk update \
    && apk upgrade \
    && pecl channel-update pecl.php.net \
    && apk add --no-cache $PHPIZE_DEPS \
        libzip-dev \
        libpng \
        libpng-dev \
        libjpeg-turbo \
        libjpeg-turbo-dev \
        freetype \
        freetype-dev \
    &&  if [ ${PHP_FPM_VERSION} = "7.3" ] || [ ${PHP_FPM_VERSION} = "7.4" ]; then \
            docker-php-ext-configure zip; \
        else \
            docker-php-ext-configure zip --with-libzip; \
        fi \
    && docker-php-ext-install \
        zip \
        pdo_mysql

# install phpredis
ARG INSTALL_PHPREDIS=false
RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      pecl install -o -f redis-4.3.0; \
    else \
      pecl install -o -f redis; \
    fi \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
;fi

# install gd
ARG INSTALL_GD=false
RUN if [ ${INSTALL_GD} = true ]; then \
    docker-php-ext-configure gd \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/ \
    && docker-php-ext-install gd \
;fi

# install opcache
ARG INSTALL_OPCACHE=false
RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
    && docker-php-ext-enable opcache \
;fi
COPY ./opcache.ini /usr/local/etc/php/conf.d

# install swoole-tracker
COPY ./swoole-tracker-install.sh /tmp
ARG INSTALL_SWOOLE_TRACKER=false
RUN if [ ${INSTALL_SWOOLE_TRACKER} = true ]; then \
    chmod +x /tmp/swoole-tracker-install.sh && \
    cd /tmp/ && \
    ./swoole-tracker-install.sh && \
    rm /tmp/swoole-tracker-install.sh && \
    cp /tmp/swoole-tracker/swoole_tracker74.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/swoole_tracker74.so && \
    printf '#!/bin/sh\n/opt/swoole/script/php/swoole_php /opt/swoole/node-agent/src/node.php &\nphp-fpm $@' > /opt/swoole/entrypoint.sh && \
    chmod 755 /opt/swoole/entrypoint.sh && \
    printf 'extension=swoole_tracker74.so' > /usr/local/etc/php/conf.d/swoole-tracker.ini \
;fi

COPY ./lumen.ini /usr/local/etc/php/conf.d

USER root

WORKDIR /var/www/html

#CMD ["php-fpm"]

EXPOSE 9000

ENTRYPOINT [ "sh", "-x", "/opt/swoole/entrypoint.sh" ]
