#!/bin/bash

set -e

# open permission for /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

# Start MariaDB temporarily (background)
mysqld_safe --skip-networking &

# Wait until MariaDB is ready
until mysqladmin ping --silent; do
    sleep 1
done

# Create database
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# Create user
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Grant privileges
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

# Apply changes
mysql -e "FLUSH PRIVILEGES;"

# Stop temporary MariaDB
mysqladmin shutdown

# Run MariaDB as PID 1
exec mysqld_safe
