#!/bin/bash
set -e

echo "WordPress container starting..."

# Read secrets from mounted files
MYSQL_USER="${MYSQL_USER:-$(cat /run/secrets/credentials 2>/dev/null)}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-$(cat /run/secrets/db_password 2>/dev/null)}"

# Validate required variables
: "${MYSQL_USER:?ERROR: MYSQL_USER not set in env or secrets}"
: "${MYSQL_PASSWORD:?ERROR: MYSQL_PASSWORD not set in env or secrets}"
: "${MYSQL_DATABASE:?ERROR: MYSQL_DATABASE not set}"
: "${DB_HOST:?ERROR: DB_HOST not set}"

test_db_connection() {
	mysql -h "${DB_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1;" "${MYSQL_DATABASE}" >/dev/null 2>&1
}

counter=0
until test_db_connection
do
	counter=$((counter + 1))
	if [ $counter -gt 30 ]; then
		echo "ERROR: Could not connect to MariaDB after 60 seconds"
		echo "Trying to debug connection..."
		mysql -h "${DB_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1;" 2>&1 || true
		exit 1
	fi
	echo "Waiting for MariaDB to be ready... (attempt $counter/30)"
	sleep 2
done

echo "MariaDB is ready!"

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Installing WordPress..."
	cd /var/www/html
	rm -f index.nginx-debian.html
	echo "Downloading WordPress..."
	wp core download --allow-root --locale=en_US
	echo "Creating wp-config.php..."
	wp config create --allow-root \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASSWORD}" \
		--dbhost="${DB_HOST}" \
		--skip-check
	echo "Installing WordPress core..."
	wp core install --allow-root \
		--url="${WP_URL}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}"
	chown -R www-data:www-data /var/www/html
	chmod -R 755 /var/www/html
	echo "WordPress installation completed!"
else
	echo "WordPress is already installed."
fi

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F