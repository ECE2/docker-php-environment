#
#
#

ARG PHP_FPM_VERSION
FROM php:${PHP_FPM_VERSION}-alpine

USER root

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

# crontab
RUN echo "* * * * * cd /var/www/html/backend && php artisan schedule:run >> /dev/null 2>&1" > /etc/crontabs/root

WORKDIR /var/www/html

ADD ./startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh
CMD ["/bin/sh", "/opt/startup.sh"]
