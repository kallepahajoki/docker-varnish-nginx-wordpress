#! /bin/bash
echo -n "Enter site name: "
read site
mkdir -p sites/$site

SITENAME="`echo $site|tr -d .`"
PW=`openssl rand -hex 12`

cat > sql/$site.sql << :EOF:

CREATE DATABASE $SITENAME;
CREATE USER '$SITENAME'@'localhost' IDENTIFIED BY '$PW';
GRANT ALL PRIVILEGES ON $SITENAME.* TO '$SITENAME'@'localhost';

:EOF:

source pw/mysql
echo DB_PASSWORD=$PW> pw/$site

docker run --name gendb -d -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -v $PWD/db:/var/lib/mysql -v $PWD/sql/$site.sql:/docker-entrypoint-initdb.d/schema.sql mariadb
cd sites/$site

wget https://fi.wordpress.org/latest-fi.tar.gz
tar xvfz latest-fi.tar.gz
rm *.gz
mv wordpress/* .
rmdir wordpress
sleep 5
docker stop gendb
docker rm gendb


