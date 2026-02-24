FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/xxx.42.fr.key \
    -out /etc/nginx/ssl/xxx.42.fr.crt \
    -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/CN=login.42.fr"

# Copy main nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy server block
COPY conf/default.conf /etc/nginx/sites-available/default

# Enable site
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Remove default nginx site if exists
RUN rm -f /etc/nginx/sites-enabled/default.default 2>/dev/null || true

# Create WordPress directory
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]