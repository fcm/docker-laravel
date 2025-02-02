FROM php:7.3.6-fpm-alpine3.9

# Instalando dependencias php
RUN apk add bash mysql-client
RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www
RUN rm -rf /var/www/html

# Instalando o composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

# Copia a aplicação para o container
COPY . /var/www

RUN ln -s public html

RUN composer install \
    && cp .env.example .env \
    && php artisan key:generate \
    && php artisan config:cache

# Carbon 1 is deprecated, see how to migrate to Carbon 2.
#RUN php ./vendor/bin/upgrade-carbon --no-interaction --quiet

EXPOSE 9000
ENTRYPOINT ["php-fpm"]
