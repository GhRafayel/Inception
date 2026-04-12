#!/bin/sh

set -e

# Validate domain name is provided
: "${DOMAIN_NAME:?ERROR: DOMAIN_NAME environment variable not set}"

# Extract just the domain name without .42.fr suffix for certificate naming
DOMAIN_CERT="${DOMAIN_NAME}.42.fr"

if [ ! -f "/etc/nginx/ssl/${DOMAIN_CERT}.crt" ]; then
    echo "Certificate not found, generating..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "/etc/nginx/ssl/${DOMAIN_CERT}.key" \
        -out "/etc/nginx/ssl/${DOMAIN_CERT}.crt" \
        -subj "/C=FR/ST=Ile-de-France/L=Paris/O=42/CN=${DOMAIN_CERT}"
fi

# Replace template variable with actual domain name
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
