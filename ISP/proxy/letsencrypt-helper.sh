#!/bin/bash
# ==============================================================================
# NexusTech ISP - Let's Encrypt SSL Certbot Helper Script
# ==============================================================================
# Este script automatiza a obtenção de certificados SSL/TLS da Let's Encrypt
# usando o Certbot em contêineres Docker.
# 
# IMPORTANTE: Para que este script funcione em ambiente real:
# 1. Os domínios (nexustech.com.br, salesfilho.com.br, etc.) devem apontar 
#    para o IP público do seu servidor através do DNS público.
# 2. A porta 80 do seu servidor deve estar aberta e exposta para a internet.
# ==============================================================================

EMAIL="admin@nexustech.com.br"
DOMAINS="nexustech.com.br,www.nexustech.com.br,webmail.nexustech.com.br,salesfilho.com.br,www.salesfilho.com.br,sign.salesfilho.com.br,cliente2.com.br,www.cliente2.com.br,cms.cliente2.com.br,cliente3.com.br,www.cliente3.com.br,cms.cliente3.com.br"

echo "======================================================================"
echo "          Let's Encrypt SSL/TLS Certificate Helper - Certbot"
echo "======================================================================"

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "Erro: Docker não está instalado ou não está no PATH."
    exit 1
fi

read -p "Deseja executar em modo de homologação (Staging/Teste)? [S/n]: " staging_choice
STAGING_FLAG=""
if [ "$staging_choice" != "n" ] && [ "$staging_choice" != "N" ]; then
    echo "-> Executando em modo STAGING (Certificados de teste do Let's Encrypt)."
    STAGING_FLAG="--staging"
else
    echo "-> Executando em modo PRODUÇÃO (Certificados válidos do Let's Encrypt)."
fi

echo "-> Criando diretórios para persistência do Certbot..."
mkdir -p certbot/conf certbot/www

echo "-> Iniciando solicitação de certificado SSL/TLS via Certbot..."
docker run -it --rm \
    -v "$(pwd)/certbot/conf:/etc/letsencrypt" \
    -v "$(pwd)/certbot/www:/var/www/certbot" \
    certbot/certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    $STAGING_FLAG \
    -d nexustech.com.br -d www.nexustech.com.br -d webmail.nexustech.com.br -d salesfilho.com.br -d www.salesfilho.com.br -d sign.salesfilho.com.br -d cliente2.com.br -d www.cliente2.com.br -d cms.cliente2.com.br -d cliente3.com.br -d www.cliente3.com.br -d cms.cliente3.com.br

echo "======================================================================"
echo "Como integrar com o Nginx (proxyISP):"
echo "1. No arquivo 'compose.yaml', monte o volume do Let's Encrypt no Nginx:"
echo "   - ./certbot/conf:/etc/nginx/ssl:ro"
echo "2. No arquivo 'default.conf' do Nginx, ajuste os caminhos dos certificados:"
echo "   ssl_certificate /etc/nginx/ssl/live/nexustech.com.br/fullchain.pem;"
echo "   ssl_certificate_key /etc/nginx/ssl/live/nexustech.com.br/privkey.pem;"
echo "======================================================================"
