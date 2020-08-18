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
ENV COMPOSER_VERSION=1.9.1

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
    # install composer
    && cd /tmp \
    && wget https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && chmod u+x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \

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
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

COPY ./lumen.ini /usr/local/etc/php/conf.d

USER root

WORKDIR /var/www/html

CMD ["php-fpm"]

EXPOSE 9000
