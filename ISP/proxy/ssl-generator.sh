#!/bin/sh
set -e

mkdir -p /etc/nginx/ssl

# Gerar certificado autoassinado para os domínios se não existir
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "[ssl-generator.sh] Gerando certificado SSL autoassinado..."
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/CN=nexustech.com.br" \
        -addext "subjectAltName=DNS:nexustech.com.br,DNS:*.nexustech.com.br,DNS:salesfilho.com.br,DNS:*.salesfilho.com.br,DNS:cliente2.com.br,DNS:*.cliente2.com.br,DNS:cliente3.com.br,DNS:*.cliente3.com.br,DNS:localhost"
    
    chmod 644 /etc/nginx/ssl/nginx.crt
    chmod 600 /etc/nginx/ssl/nginx.key
    echo "[ssl-generator.sh] Certificado SSL gerado com sucesso em /etc/nginx/ssl/."
else
    echo "[ssl-generator.sh] Certificado SSL já existe."
fi
