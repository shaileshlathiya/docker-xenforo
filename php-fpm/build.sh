#!/bin/sh

set -e

RUN_PACKAGES=""
TMP_PACKAGES=""
TMP_PACKAGES="$TMP_PACKAGES autoconf"
RUN_PACKAGES="$RUN_PACKAGES cyrus-sasl-dev"     # memcached
RUN_PACKAGES="$RUN_PACKAGES freetype-dev"       # gd
TMP_PACKAGES="$TMP_PACKAGES g++"
TMP_PACKAGES="$TMP_PACKAGES git"
RUN_PACKAGES="$RUN_PACKAGES imagemagick"        # imagick
TMP_PACKAGES="$TMP_PACKAGES imagemagick-dev"    # imagick
RUN_PACKAGES="$RUN_PACKAGES libjpeg-turbo-dev"  # gd
RUN_PACKAGES="$RUN_PACKAGES libmcrypt-dev"      # mcrypt
RUN_PACKAGES="$RUN_PACKAGES libmemcached"       # memcached
TMP_PACKAGES="$TMP_PACKAGES libmemcached-dev"   # memcached
RUN_PACKAGES="$RUN_PACKAGES libpng-dev"         # gd
TMP_PACKAGES="$TMP_PACKAGES libtool"
RUN_PACKAGES="$RUN_PACKAGES libwebp-dev"        # gd
RUN_PACKAGES="$RUN_PACKAGES libxml2-dev"        # xml
TMP_PACKAGES="$TMP_PACKAGES make"
RUN_PACKAGES="$RUN_PACKAGES zlib-dev"           # memcached
eval "apk add --update --no-cache $TMP_PACKAGES $RUN_PACKAGES"

# for gd
docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-webp-dir=/usr/include/

# for memcached
git clone --branch php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached/ 

docker-php-source extract
eval "docker-php-ext-install $DOCKER_XENFORO_PHP_EXT_INSTALL"
eval "pecl install $DOCKER_XENFORO_PHP_PECL_INSTALL"
eval "docker-php-ext-enable $DOCKER_XENFORO_PHP_PECL_INSTALL"
docker-php-source delete

# clean up
eval "apk del $TMP_PACKAGES"
rm -rf /tmp/* /var/cache/apk/*