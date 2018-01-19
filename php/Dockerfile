FROM php:7-fpm

# Install modules
RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-install pdo_mysql
#RUN docker-php-ext-configure mysql --with-mysql=mysqlnd
#gitRUN docker-php-ext-install mysql
