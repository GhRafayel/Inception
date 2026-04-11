*This project has been created as part of the 42 curriculum by <rghazary>

#inception - Docker Infrastructure Project 

## Description 

This project consists of building a small, secure, and modular web infrastructure using Docker
and Docker Compose. The goal is to deploy a WordPress website powerd by PHP-FPM and MariaDB, served 
through an NGINX container configured with TLS (v1.2 or v1.3).

Each servic runs in its own container, built from scratch using custom Dockerfiles based on a stable 
Debian image. The infrastructure uses Docker networking for inter-service communication and 
named volumes for persistent data storage.

the project emphasizes best practices in containerizatio, security (no hardcoded credentials), and 
reproducibility through environment variables and ".enc" configuratons.

## Instructions 

### Prerequisites 

* Docker
* Docker Compose
* Make

#### Setup 

1. Clone the repository:
    ``` bash
    git clone "URL"
    cd Inception
    cd srcs

2. Create a ".env" file and define required environment variables. 
    * Domain name
    * Database Credentials
    * WordPress users 
    * or use ".env_copy" to have all Variabls names; 

3. Updata you ` /etc/hosts` file;
    ```
    localhost // 127.0.0.1 <your login>.42.fr
    make 
4. Build and start the project:
    make 
    
### Usage 

* Access the website:
    https://<login>.42.fr

* Stop containers:
    make down
* Clean everything (containers, voumes, images);
    make fclean
* Get help to using Make file 
    make --help

### Makefile commands 

* make all       - Build and start all containers"
* make build     - Build Docker images"
* make up        - Start containers"
* make down      - Stop containers"
* make restart   - Restart all containers"
* make clean     - Stop containers and remove volumes"
* make fclean    - Full clean (containers, images, volumes, data)"
* make logs      - View container logs"
* make re        - Rebuild everything from scratch"
* make help      - Show this help message"


## Project Architectur 
    Inception/
        srcs/
            requirements/
                mariadb/
                    conf/
                        my.cnf
                    tools/
                        mariadb_init.sh
                    Dockerfile
                nginx/
                    conf/
                        demo.42.fr.conf
                        nginx.conf
                    Dockerfile
                wordpress/
                    conf/
                        wwww.conf
                    tolls/
                        wordpress_init.sh
                    Dockerfile
            mv to here .env (after creating .env or using .env_copy)
            docker-compose.yml
        .gitignore/
        .env_copy
        Makefile
        README.md


### Services
    * ** NGINX **: Hendled HTTPS staffic (TLSv1.2/1.3) on port 443
    * ** WordPress + PHP_FPM**: Precesses dynamic content
    * ** MariaDB **: Stroes WordPress database 

### Volumes
    * WordPress database volume
    * WordPress files volume
    Both are Docker named voumes mapped to:

### Networking 
    * Constom Docker network connects all containers securely 

### Docker vs Virtual Machines
    * Environment variables are simple but less secure
    * Docker secrets provide better protection for sensitive data
    * This project used ".env" but recommends secrets for production

### Docker Network vs Host Network

* Docker network isolates services and improves security 
* Host network removes isolation and is forbidden in this project

### Docker vlumes vs Bind Mounts 
    * Named volumes are managed by Docker and more portable 
    * Bind mounts depend on host structur and are less flexigle
    * Named volumes are required for this project 

## Resiyrces 

* Docker Documentation: https://docs.docker.com/
* Docker compose Documentation: https://docs.docker.com/compose/
* NGINX Documentation: https://nginx.org/en/docs/
* WordPress Documentations: https://wordpress.org/support/
* Mariadb Documentation: https://mariadb.org/documentation/

All configurations and implementation logic were reviewed and adapted manually.
