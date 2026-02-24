FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Copy config
COPY conf/my.cnf /etc/mysql/my.cnf

# Copy init script
COPY tools/mariadb_init.sh /usr/local/bin/mariadb_init.sh
RUN chmod +x /usr/local/bin/mariadb_init.sh

EXPOSE 3306

# Run as root, init script will switch to mysql user for mysqld
ENTRYPOINT ["/usr/local/bin/mariadb_init.sh"]