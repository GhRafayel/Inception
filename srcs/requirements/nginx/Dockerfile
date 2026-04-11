FROM debian:bookworm

RUN apt-get update && apt-get install -y \ 
    nginx \
    openssl \
    gettext && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY tools/nginx_init.sh /nginx_init.sh

RUN chmod 775 /nginx_init.sh

EXPOSE 443

ENTRYPOINT ["/nginx_init.sh"]