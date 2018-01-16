#! /bin/sh
cd varnish
mkdir -p pw
mkdir -p sql
mkdir -p db
sh generate-varnish.sh
cd ..
cd nginx
sh generate-nginx.sh
cd ..
sh generate-compose.sh
docker-compose -d up
