FROM debian:bullseye

RUN apt update && apt install -y \
    nginx \
    openssl \
    && apt clean

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Copy nginx config
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Copy init script
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 443

ENTRYPOINT ["/init.sh"]
