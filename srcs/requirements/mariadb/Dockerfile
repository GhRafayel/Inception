FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Data directories
RUN mkdir -p /var/lib/mysql /var/run/mysqld && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Copy init script
COPY tools/mariadb_init.sh /usr/local/bin/mariadb_init.sh
RUN chmod +x /usr/local/bin/mariadb_init.sh

# Copy MariaDB config
COPY conf/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

CMD ["/usr/local/bin/mariadb_init.sh"]