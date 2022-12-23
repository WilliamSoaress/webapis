FROM php:8.0-apache

# Instale as dependências do PHP
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && docker-php-ext-install -j$(nproc) zip

# Instale o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copie os arquivos do projeto para o diretório de trabalho do Apache
COPY . /var/www/html

# Defina a pasta de trabalho do Composer
WORKDIR /var/www/html

# Execute o Composer para instalar as dependências do projeto
RUN composer install --no-dev --optimize-autoloader
