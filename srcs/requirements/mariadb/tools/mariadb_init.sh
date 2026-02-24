#!/bin/bash
set -e

echo "=== MariaDB Init Script Starting ==="

# Check if data directory is initialized
if [ ! -d "/var/lib/mysql/wordpress" ]; then
    echo ">>> Database not initialized, starting setup..."
    
    # Initialize data directory
    echo ">>> Running mysql_install_db..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm
    
    # Start temporary server
    echo ">>> Starting temporary mysqld..."
    mysqld --user=mysql --skip-networking &
    pid="$!"
    
    # Wait for server to be ready
    echo ">>> Waiting for temporary server to be ready..."
    until mysqladmin ping --silent 2>/dev/null; do
        echo "    ...waiting"
        sleep 1
    done
    echo ">>> Temporary server is ready!"
    
    # Setup database and users
    echo ">>> Creating database and users..."
    echo "    DB: ${MYSQL_DATABASE}"
    echo "    USER: ${MYSQL_USER}"
    
    mysql -u root << EOF
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOF
    
    echo ">>> Database setup completed!"
    
    # Shutdown temporary server
    echo ">>> Shutting down temporary server..."
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait $pid || true
    
    echo ">>> Initialization complete!"
else
    echo ">>> Database already initialized, skipping setup"
fi

# Fix permissions
echo ">>> Fixing permissions..."
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Start MariaDB
echo ">>> Starting MariaDB..."
exec mysqld --user=mysql