FROM debian:bullseye

WORKDIR /var/www/html

RUN sed -i 's|deb.debian.org|ftp.de.debian.org|g' /etc/apt/sources.list \
    && apt update \
    && apt install -y \
        php \
        php-fpm \
        php-mysql \
        wget \
        unzip \
        gettext \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*


# Clean folder before extracting
RUN rm -rf /var/www/html/*

# Download and extract WordPress
RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz

# Copy wp-config.php if you have one
# COPY wp-config.php /var/www/html/wp-config.php

# Copy init script (if needed)
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Configure php-fpm to listen on port 9000
RUN sed -i 's|listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

ENTRYPOINT ["/init.sh"]
