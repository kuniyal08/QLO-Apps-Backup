# syntax=docker/dockerfile:1

# QloApps is a PrestaShop 1.6 fork. Apache keeps the development stack
# simple: no shared application-code volume and no nginx/php service DNS.
FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gettext \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libonig-dev \
        libpng-dev \
        libwebp-dev \
        libxml2-dev \
        libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j"$(nproc)" \
        pdo_mysql \
        mysqli \
        gd \
        intl \
        soap \
        zip \
        gettext \
        mbstring \
        opcache \
    && a2enmod rewrite headers expires \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY docker/php/php.ini /usr/local/etc/php/conf.d/zz-qloapps.ini
COPY docker/apache/qloapps.conf /etc/apache2/sites-available/000-default.conf
COPY docker/apache/servername.conf /etc/apache2/conf-available/qloapps-servername.conf
COPY docker/php/generate-settings.php docker/php/configure-database.php /usr/local/lib/qloapps/
COPY scripts/seed-rural-up-demo.php /usr/local/bin/seed-rural-up-demo

RUN a2enconf qloapps-servername

WORKDIR /var/www/html
COPY . /var/www/html

# Preserve initial media outside the volume mount points so empty media
# volumes can be seeded on first start. Docker-only files are not web content.
RUN mkdir -p \
        /usr/local/share/qloapps-media/img \
        /usr/local/share/qloapps-media/upload \
        /usr/local/share/qloapps-media/download \
        /var/www/html/cache/smarty/compile \
        /var/www/html/cache/smarty/cache \
        /var/www/html/log \
        /var/www/html/var/logs \
        /var/www/html/var/cache \
        /var/www/html/var/sessions \
    && cp -a /var/www/html/img/. /usr/local/share/qloapps-media/img/ \
    && cp -a /var/www/html/upload/. /usr/local/share/qloapps-media/upload/ \
    && cp -a /var/www/html/download/. /usr/local/share/qloapps-media/download/ \
    && rm -rf /var/www/html/docker /var/www/html/scripts

COPY docker/php/entrypoint.sh /usr/local/bin/qloapps-entrypoint
RUN chmod +x /usr/local/bin/qloapps-entrypoint /usr/local/bin/seed-rural-up-demo

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/qloapps-entrypoint"]
CMD ["apache2-foreground"]
