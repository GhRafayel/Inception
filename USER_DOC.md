# USER DOCUMENTATION 

## Overview 

This project provides a small web infrastructrue composed of three main services:

- ** NGINX**: Acts as the secure entry point (HTTPS only, port 443).
- ** WordPress + PHP-FPM**: Handles the website logic and content.
- ** MariaDB ** : Stroes the website database. 

All services run inside Docker containers and communicate through a Docker network.

--- 

### Available Services

- A sucure website accessible via HTTPS
- A WordPress administration panel
- A database backed (MariaDb)

---

## Important. Before using make command:
    1.  Create .env file and put in root using .env_copy file 


## Starting the Project  
        * * * make * * *

### This will :
    * Build Docker images
    * Create containers 
    * Start all services
------------------------------------------


## Stoping the Project  
        * * *  make down * * *

------------------------------------------

## Clingin all created files for containers   
        * * * make fclean * * * 

##  Restart the project 
    * * * make re * * * 

## Cecking Service Status 
    * * * docker ps * * * 

##  Cecking logs 
    * * * docker logs * * * // for all containers 
    * * * docker logs <container name > * * * 

# Accessing the Website
    1. Make sure your domain is configured (example);
        *** <login>.42.fr
    2. Open your brawser and go to:
        *** https://<login>.42.fr
    
# Accessing WordPress Admin Panel
    *** https://<login>.42.fr/<admin name>

