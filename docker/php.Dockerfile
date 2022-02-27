FROM php:8-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql

#removing the annoying error bell in shell
RUN echo "set bell-style visible" > ~/.inputrc

RUN apt update \
	&& apt -y upgrade \
	&& apt -y install vim git zip zsh

# PHP config
RUN pecl install xdebug
RUN touch /var/log/php_error.log && chmod og+w /var/log/php_error.log

# Apache configuration
RUN a2enmod rewrite \
	&& echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf \
	&& sed -i 's/\/var\/www\/html/\/var\/www\/html\/public/g' /etc/apache2/sites-enabled/000-default.conf

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Permissions
RUN groupadd -g 1000 app
RUN useradd app -g app -u 1000 -m
RUN chown -R app:app /var/www
WORKDIR /var/www/html
