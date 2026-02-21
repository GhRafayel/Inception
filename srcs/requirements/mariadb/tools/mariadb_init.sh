#!/bin/bash

set -e

# Initialize MariaDB data directory if it doesn't exist
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB database..."

    # Create required directory
    mkdir -p /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

    # Initialize database
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "MariaDB initialization completed!"

    # Start temporary MariaDB server (without auth)
    mysqld_safe --skip-grant-tables &
    MYSQLD_PID=$!

    sleep 5

    # Configure database
    mysql -u root <<  EOF
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
        FLUSH PRIVILEGES; 
EOF

    # Shutdown temporary server
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

    echo "Database setup completed!"
fi

# Fix permissions again
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Start MariaDB normally
exec su mysql -s /bin/bash -c "mysqld_safe --user=mysql"