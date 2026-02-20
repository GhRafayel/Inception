#!/bin/bash

set -e

# Wait for MariaDB to be ready
while ! nc -z ${DB_HOST} 3306; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."
    
    # Download WordPress
    cd /var/www/html
    wp core download --allow-root --locale=en_US
    
    # Create wp-config.php
    wp config create \
        --allow-root \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=${DB_HOST} \
        --skip-check
    
    # Install WordPress
    wp core install \
        --allow-root \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}
    
    # Fix permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    
    echo "WordPress installation completed!"
else
    echo "WordPress is already installed."
fi

# Start PHP-FPM
exec php-fpm8.2 -F