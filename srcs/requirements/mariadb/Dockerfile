FROM debian:bookworm

RUN apt-get update && apt-get install -y \ 
    mariadb-server \ 
    mariadb-client \ 
    && rm -rf /var/lib/apt/lists/*

# Create MariaDB data directory
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# Copy initialization script
COPY tools/mariadb_init.sh /usr/local/bin/mariadb_init.sh
RUN chmod +x /usr/local/bin/mariadb_init.sh

# Copy my.cnf for MySQL configuration
COPY conf/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

CMD ["/usr/local/bin/mariadb_init.sh"]