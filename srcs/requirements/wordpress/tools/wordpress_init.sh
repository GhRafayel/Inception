#!/bin/bash

set -e

until mysql -h ${DB_HOST} -u ${MYSQL_USER} -p"${MYSQL_PASSWORD}" -e "SELECT 1;" >/dev/null 2>&1
do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."
    
    cd /var/www/html
    
    wp core download --allow-root --locale=en_US
    
    wp config create \
        --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=${DB_HOST} \
        --skip-check
    
    wp core install \
        --allow-root \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}
    
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    
    echo "WordPress installation completed!"
else
    echo "WordPress is already installed."
fi

exec php-fpm8.2 -F