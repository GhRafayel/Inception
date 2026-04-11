#!/bin/bash
set -e

echo "=== Mariadb Init Script Starting ==="

if [ ! -d "/var/lib/mysql/mysql" ]; then

    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm

    mysqld --user=mysql --skip-networking & pid="$!"

    until mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done

    mysql -u root << EOF
        FLUSH PRIVILEGES;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOF
   
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait $pid || true

fi

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
exec mysqld --user=mysql 