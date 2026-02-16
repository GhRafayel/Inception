#!/bin/bash

set -e

# Generate self-signed certificate if not exists
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=AT/ST=Vienna/L=Vienna/O=42/OU=student/CN=localhost"
fi

# Run nginx as PID 1
exec nginx -g "daemon off;"
