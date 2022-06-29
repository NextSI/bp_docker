FROM php:7.4-apache

# Copiando configurações específicas do php.ini
COPY php-especifico.ini /usr/local/etc/php/conf.d/

# Copiando o arquivo do ioncube
COPY ioncube_loader_lin_7.4.so /var/www

RUN a2enmod rewrite

# Copiando os arquivos do BP para a pasta /var/www/html
COPY ./bp/ /var/www/html

# Acessando a Pasta /var/www
RUN cd /var/www

# Instalando o IonCube
RUN mv /var/www/ioncube_loader_lin_7.4.so `php-config --extension-dir` && docker-php-ext-enable ioncube_loader_lin_7.4

# Instalando o LDAP
RUN apt-get update && apt-get install libldap2-dev -y && rm -rf /var/lib/apt/lists/* && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && docker-php-ext-install ldap

# Instalando o GD
RUN apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) gd

# Instalando o IMAP
RUN apt-get install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/* && docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap

# Instalando o ZIP
RUN apt-get update && apt-get install -y libzip-dev && docker-php-ext-install zip

# Instalando o MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Criando a pasta data
RUN mkdir data

# Definindo o diretório de trabalho
WORKDIR /var/www/html