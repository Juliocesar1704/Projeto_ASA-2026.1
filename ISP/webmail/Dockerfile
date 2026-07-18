FROM nextcloud:34-apache

# Usar o instalador de extensões PHP oficial para gerenciar automaticamente a compilação e dependências do IMAP (mesmo com PECL/Debian Trixie)
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions imap

# Criar a pasta de hooks se não existir e copiar o script de configuração
RUN mkdir -p /docker-entrypoint-hooks.d/before-starting
COPY setup-imap.sh /docker-entrypoint-hooks.d/before-starting/setup-imap.sh
RUN chmod +x /docker-entrypoint-hooks.d/before-starting/setup-imap.sh
