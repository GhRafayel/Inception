#!/bin/sh 

set -e

if [ ! -f /etc/nginx/ssl/${DOMAIN_NAME}.42.fr.crt ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/${DOMAIN_NAME}.42.fr.key \
        -out /etc/nginx/ssl/${DOMAIN_NAME}.42.fr.crt \
        -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/CN=${DOMAIN_NAME}.42.fr"
fi

envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
