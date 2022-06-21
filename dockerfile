FROM php:7.4-apache

# Copiando configurações específicas do php.ini
COPY php-especifico.ini /usr/local/etc/php/conf.d/

# Instalando o IonCube
RUN curl -fSL 'http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz' -o ioncube.tar.gz \
    && mkdir -p ioncube \
    && tar -xf ioncube.tar.gz -C ioncube --strip-components=1 \
    && rm ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.4.so /var/www/ioncube_loader_lin_7.4.so \
    && rm -r ioncube

RUN a2enmod rewrite

# Copiando os arquivos do BP para a pasta /var/www/html
COPY ./bp/ /var/www/html

# Acessando a Pasta /var/www
RUN cd /var/www

# Criando a pasta data
RUN mkdir data

# Definindo o diretório de trabalho
WORKDIR /var/www/html