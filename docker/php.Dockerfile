FROM php:8-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql

#removing the annoying error bell in shell
RUN echo "set bell-style visible" > ~/.inputrc

RUN apt update
RUN apt -y upgrade
RUN apt -y install vim git zip
RUN pecl install xdebug

COPY php/conf.d/* /usr/local/etc/php/conf.d/

RUN touch /var/log/php_error.log && chmod og+w /var/log/php_error.log

COPY apache/envvars /etc/apache2/envvars

# Apache configuration
RUN a2enmod rewrite
RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf
RUN sed -i 's/\/var\/www\/html/\/var\/www\/html\/public/g' /etc/apache2/sites-enabled/000-default.conf

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/html
