FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libonig-dev libpng-dev libzip-dev unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" gd mbstring mysqli pdo_mysql zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html/application/config /var/www/html/upload /var/www/html/tmp /var/www/html/assets
RUN chmod +x /var/www/html/deploy/calmos-entrypoint.sh
ENTRYPOINT ["/var/www/html/deploy/calmos-entrypoint.sh"]
CMD ["apache2-foreground"]
