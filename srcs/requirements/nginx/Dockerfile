FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create SSL certificates directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/demo.42.fr.key \
    -out /etc/nginx/ssl/demo.42.fr.crt \
    -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/CN=demo.42.fr"

# Copy nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/demo.42.fr.conf /etc/nginx/sites-available/demo.42.fr

# Enable the site
RUN ln -sf /etc/nginx/sites-available/demo.42.fr /etc/nginx/sites-enabled/demo.42.fr

# Remove default site
RUN rm -f /etc/nginx/sites-enabled/default

# Create www directory
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]