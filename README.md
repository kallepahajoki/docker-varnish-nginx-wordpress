# docker-varnish-nginx-wordpress
A repository for a set of dockerfiles and scripts for running multiple wordpress sites using varnish + nginx + wordpress + php-fpm installation on docker

## The architeture

These are the architecture requirements for this project

- Single nginx instance will terminate SSL for all sites and forward to Varnish at port 80.
- A single mariaDB instance will run to provide database connection for each of the sites. Each site will use a unique username/password
- A single varnish cache will be run on the frontend at port 80 and forward traffic to the nginx containers running the wordpress sites
- A single php-fpm container will run, providing PHP for all nginx containers
- Multiple nginx containers will be run, one for each wordpress site, only able to access the webroot of that particular wordpress site and the 
- New sites will be easy to add using a shell script



