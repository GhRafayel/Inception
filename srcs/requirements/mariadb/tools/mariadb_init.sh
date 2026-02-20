#!/bin/bash

set -e

# Initialize MariaDB data directory if it doesn't exist
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB database..."
    
    # Create necessary directories
    mkdir -p /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld
    chown -R mysql:mysql /var/lib/mysql
    
    # Initialize the database
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    
    echo "MariaDB initialization completed!"
fi

# Fix permissions
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld

# Start MariaDB in the background for setup
mysqld_safe --skip-grant-tables &
MYSQLD_PID=$!

# Wait for MariaDB to start
sleep 3

# Set root password and create user
mysql -u root << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \
`${MYSQL_DATABASE}`\;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \
`${MYSQL_DATABASE}`\.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Kill the background MariaDB process
kill $MYSQLD_PID
wait $MYSQLD_PID 2>/dev/null || true

# Start MariaDB in foreground
exec mysqld_safe