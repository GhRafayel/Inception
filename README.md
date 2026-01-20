inception/
├── Makefile
├── docker-compose.yml
└── srcs/
    ├── requirements/
    │   ├── nginx/
    │   │   ├── Dockerfile
    │   │   └── conf/
    │   │       └── nginx.conf
    │   ├── wordpress/
    │   │   ├── Dockerfile
    │   │   └── conf/
    │   │       └── wp-config.php
    │   └── mariadb/
    │       ├── Dockerfile
    │       └── conf/
    │           └── my.cnf
    └── .env

///////////////////////  Step 1 //////////////////////////////////////////////////
NGINX

	Acts as HTTPS reverse proxy

	Uses TLS (SSL)

	Listens on 443 only

WordPress

	PHP-FPM (no Apache)

	Connects to MariaDB

	No hardcoded credentials

MariaDB

	Database for WordPress

	No root login from outside

	Uses env variables

//////////////// Step 2  .env example /////////////////////

DOMAIN_NAME=login.42.fr

MYSQL_ROOT_PASSWORD=strongrootpass
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wppassword

WP_TITLE=Inception
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=adminpass
WP_ADMIN_EMAIL=admin@email.com
WP_USER=student
WP_USER_PASSWORD=studentpass
WP_USER_EMAIL=student@email.com


///////////////////////  Step 3 //////////////////////////////////////////////////

		MariaDB container (start here)
		

MariaDB Dockerfile goals:

	Base: debian:bullseye

	Install mariadb-server

	Create database + user using env vars

	Listen only on Docker network

You must understand:

	Difference between RUN and CMD

	Why DB init happens only once

	How volumes persist data


///////////////////////  Step 4 //////////////////////////////////////////////////


Goals
	
	PHP + PHP-FPM

	Download WordPress via CLI

	Configure wp-config.php using env vars

	Auto-install WordPress
	

Key points:

	No Apache

	Use php-fpm on port 9000

	Wait for MariaDB before starting




///////////////////////  Step 5 //////////////////////////////////////////////////



Goals:

	HTTPS only

	TLS certificate (self-signed)

	Proxy requests to WordPress (PHP-FPM)
	
Important:

	Expose only port 443

	No latest tag

	TLS config must be correct


///////////////////////  Step 6 //////////////////////////////////////////////////


Your docker-compose.yml must:

	Define 3 services

	Use volumes for:

		/var/lib/mysql

		/var/www/html

	Use custom network

	Use .env	

------------------- Example structure ---------------------

services:
  mariadb:
    build: srcs/requirements/mariadb
    volumes:
      - db:/var/lib/mysql
    env_file:
      - srcs/.env

  wordpress:
    build: srcs/requirements/wordpress
    volumes:
      - wp:/var/www/html
    depends_on:
      - mariadb
    env_file:
      - srcs/.env

  nginx:
    build: srcs/requirements/nginx
    ports:
      - "443:443"
    volumes:
      - wp:/var/www/html
    depends_on:
      - wordpress

volumes:
  db:
  wp:
  
  
///////////////////////  Step 7 Makefile //////////////////////////////////////////////////


all:
	docker-compose up --build

down:
	docker-compose down

clean:
	docker system prune -af

re: clean all



///////////////////////  Step 8 Testing checklist (VERY IMPORTANT) //////////////////////////////////////////////////



✅ docker ps shows 3 containers
✅ https://login.42.fr works
✅ No container crashes
✅ Volumes persist after reboot
✅ docker inspect shows no latest
✅ No passwords in Dockerfiles
✅ NGINX only exposes 443



