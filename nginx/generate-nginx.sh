#!/usr/bin/env bash
rm -f ssl/* non-ssl/*
for site in `ls ../sites`
do
    SITENAME="`echo $site|tr -d .`"

    cat > ssl/$site.conf << :EOF:

  server {
        listen *:443 ssl;
        ssl on;
	server_name  www.$site;

	ssl_certificate /etc/letsencrypt/live/www.$site/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/www.$site/privkey.pem;
location / {
    proxy_pass            http://varnish:80;
    proxy_read_timeout    90;
    proxy_connect_timeout 90;
    proxy_redirect        off;

    proxy_set_header      X-Real-IP \$remote_addr;
    proxy_set_header      X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header      X-Forwarded-Proto https;
    proxy_set_header      X-Forwarded-Port 443;
    proxy_set_header X-Forwarded-Protocol \$scheme;
    proxy_set_header      Host \$host;
  }

}
  server {
        listen *:443 ssl;
        ssl on;
	server_name $site;

	ssl_certificate /etc/letsencrypt/live/$site/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$site/privkey.pem;
location / {
    proxy_pass            http://varnish:80;
    proxy_read_timeout    90;
    proxy_connect_timeout 90;
    proxy_redirect        off;

    proxy_set_header      X-Real-IP \$remote_addr;
    proxy_set_header      X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header      X-Forwarded-Proto https;
    proxy_set_header      X-Forwarded-Port 443;
    proxy_set_header X-Forwarded-Protocol \$scheme;
    proxy_set_header      Host \$host;
  }

}

:EOF:

    cat > non-ssl/$site.conf << :EOF:

server {
        listen 0.0.0.0:8080;

#	include /etc/nginx/global/rate_limit.conf;

        root /var/www/$site;
        index index.php index.html index.htm;

        server_name  ~^(.*\.)?${site}$;

        error_page 404 /404.html;
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
              root /usr/share/nginx/www;
        }

	include /etc/nginx/global/restrictions.conf;
	include /etc/nginx/global/wordpress.conf;


}

:EOF:
done
