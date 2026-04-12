#!/bin/bash
set -e

# Load combined secret file if present
if [ -f /run/secrets/secrets ]; then
    set -o allexport
    source /run/secrets/secrets
    set +o allexport
fi

# Read secrets from mounted files (preferred) or from environment variables
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-$(cat /run/secrets/db_root_password 2>/dev/null)}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-$(cat /run/secrets/db_password 2>/dev/null)}"
MYSQL_USER="${MYSQL_USER:-$(cat /run/secrets/credentials 2>/dev/null)}"
MYSQL_DATABASE="${MYSQL_DATABASE:-wordpress_db}"

# Set default hosts
MYSQL_ROOT_HOST="${MYSQL_ROOT_HOST:-localhost}"
MYSQL_USER_LOCAL="${MYSQL_USER_LOCAL:-localhost}"
MYSQL_USER_HOST="${MYSQL_USER_HOST:-%}"

# Validate required variables
: "${MYSQL_ROOT_PASSWORD:?ERROR: MYSQL_ROOT_PASSWORD not set in env or secrets}"
: "${MYSQL_DATABASE:?ERROR: MYSQL_DATABASE not set}"
: "${MYSQL_USER:?ERROR: MYSQL_USER not set in env or secrets}"
: "${MYSQL_PASSWORD:?ERROR: MYSQL_PASSWORD not set in env or secrets}"

setup_database() {
    if [ "$1" = "auth" ]; then
        mysql -u root -p"${MYSQL_ROOT_PASSWORD}"
    else
        mysql -u root
    fi << EOF
ALTER USER 'root'@'${MYSQL_ROOT_HOST}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'${MYSQL_USER_LOCAL}' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'${MYSQL_USER_HOST}' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'${MYSQL_USER_LOCAL}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'${MYSQL_USER_HOST}';
FLUSH PRIVILEGES;
EOF
}

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not found, initializing..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm

    mysqld --user=mysql --skip-networking & pid="$!"

    until mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done
    setup_database

    echo "User creation completed!"
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait $pid || true
    echo "MariaDB initialization finished!"
else
    echo "Database already exists, skipping initialization"
fi

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
exec mysqld --user=mysql &
MYSQLD_PID=$!

until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

echo "Ensuring users and database exist..."
setup_database auth

echo "MariaDB is ready!"

wait $MYSQLD_PID
