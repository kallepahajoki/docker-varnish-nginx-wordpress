#! /bin/bash

cat > docker-compose.yml <<:EOF:

version: '2'
services:
    varnish:
        ports:
            - 80:80
        image: million12/varnish
        environment:
            - VCL_CONFIG=/data/generated.vcl
        volumes:
            - $PWD/varnish/vcl:/data
        links:
:EOF:
for site in `ls sites`
do
    SITENAME="`echo $site|tr -d .`"
cat >> docker-compose.yml <<:EOF:
            - $SITENAME
    $SITENAME:
        ports:
            - 8080:8080
        image: nginx:1.13.6
        links:
            - mariadb
            - php-$SITENAME:php
        volumes:
            - $PWD/sites/$site:/var/www/$site
            - $PWD/nginx-base-conf:/etc/nginx/
            - $PWD/nginx/non-ssl:/etc/nginx/conf.d
    php-$SITENAME:
        image: php:7-fpm
        volumes:
            - $PWD/sites/$site:/var/www/$site
            - $PWD/nginx/php-fpm.conf:/etc/php-fpm/php-fpm.conf
        environment:
            - TIMEZONE=Europe/Helsinki
:EOF:

done
cat >> docker-compose.yml << :EOF:
    ssl-terminate:
        image: nginx:1.13.6
        ports:
            - 443:443
        volumes:
            - $PWD/nginx/ssl:/etc/nginx/conf.d
            - /etc/letsencrypt:/etc/letsencrypt
        links:
            - varnish
    mariadb:
        image: mariadb
        volumes:
            - $PWD/db:/var/lib/mysql
        env_file:
            - $PWD/pw/mysql
:EOF: