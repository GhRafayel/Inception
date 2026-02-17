#!/bin/bash
set -e

cd /var/www/html

# Install WordPress only if not installed yet
if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz --strip-components=1
    rm -f latest.tar.gz
fi

# Generate wp-config.php from template
envsubst < ../conf/wp-config-template.php > wp-config.php

# Start PHP-FPM as PID 1
exec php-fpm7.4 -F
