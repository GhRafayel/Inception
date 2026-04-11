# DEVELOPER DOCUMENTATION 

### Overview 

This projet uses Docker Compose to orchestrate a multi-container infrastructure:

- NGINX (TLS 1.2/1.3)
- WordPress + PHP-FPM
- MariaDB

Each service has its own Dockerfile and runs in a dedicated container.

=====================================================================

## Prerquisites

Before starting, ensure you have:

- Docker
- Docker Compose
- Make 

====================================================================

## Project Structure Typical structure:

## Project Architectur 
requirements/
    mariadb/
    nginx/
    wordpress/
docker-compose.yml
Makefile

Each service containes:

- Dockerfile 
- Configuration file
- Entry scripts (if needed)

------------------

## Enviroment Setup

1 Create a ".env  " file;

### .env file example 
    MYSQL_ROOT_PASSWORD=XXX
    MYSQL_DATABASE=wordpress_db
    MYSQL_USER=<name>
    MYSQL_PASSWORD=xxx

    DB_HOST=mariadb
    DOMAIN_NAME=name

    WP_URL=https://<logind>.42.fr
    WP_TITLE=My WardPress Site
    WP_ADMIN_USER=<admin>
    WP_ADMIN_PASSWORD=xxx
    WP_ADMIN_EMAIL=example@gmail.com
==================================================

## Managing Containers
    * docker ps                     # List running containers
    * docker stop       <name>      # Stop container
    * docker start      <name>      # Start container
    * docker logs       <name>      # View logs
    * docker exec -it   <name> sh   # Access containers shell

====================================================

# Docker Compose Usage

    * docker-compose up --build
    * docker-compose down
    * docker-compose restart
==================================================

# Volumes and Data Persistence 
    * Database
    * WordPress files
    == Stored at ==
        /home/<login>/data

## Networking 
    - Costom Docker network
    - Only NGINX exposed (port 443)

## Important Rules 
 * NO "latest" tag
 * NO infinite loops (" tail -f", "sleep infinity");
 * NO prebuilt images (except Al;ine/Dobina);
 