FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificate with proper domain
# Use build argument for login
ARG LOGIN
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/${LOGIN}.42.fr.key \
    -out /etc/nginx/ssl/${LOGIN}.42.fr.crt \
    -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/CN=${LOGIN}.42.fr"

# Copy configs
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Enable site
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Create web root
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

EXPOSE 443

# Run nginx in foreground (PID 1)
CMD ["nginx", "-g", "daemon off;"]