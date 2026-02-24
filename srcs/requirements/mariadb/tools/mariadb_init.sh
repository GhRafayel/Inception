#!/bin/bash
set -e

# Initialize MariaDB only if it hasn't been initialized yet
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB database..."

    mkdir -p /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "Temporary MariaDB start for setup..."
    mysqld_safe --user=mysql &
    MYSQLD_PID=$!
    sleep 10

    mysql -u root << EOF
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '123';
        CREATE DATABASE IF NOT EXISTS \`wordpress\`;
        CREATE USER 'user42'@'%' IDENTIFIED BY '123';
        GRANT ALL PRIVILEGES ON wordpress.* TO 'user42'@'%';
        FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p "123" shutdown
        echo "Database setup completed!"
fi
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
    exec su mysql -s /bin/bash -c "mysqld_safe --user=mysql"