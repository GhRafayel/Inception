FROM debian:bullseye

RUN apt update && apt install -y mariadb-server

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

RUN chown -R mysql:mysql /var/lib/mysql

ENTRYPOINT ["/init.sh"]
