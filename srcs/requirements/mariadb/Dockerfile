FORM dabian:latest

RUN apt-get update && apt-get install -y mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/mysql /var/run/mysqld && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

COPY conf/my.cnf /etc/mysql/my.cnf

COPY tools/mariadb_init.sh /usr/local/bin/mariadb_init.sh
RUN chmod +x /usr/local/bin/mariadb_init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb_init.sh"]