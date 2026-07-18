#!/bin/bash
set -e

echo "=== [NexusTech Setup] Iniciando configuração de Autenticação IMAP ==="

# Aguardar o arquivo config.php estar presente (indica que a instalação básica ocorreu)
until [ -f /var/www/html/config/config.php ]; do
  echo "Aguardando inicialização do Nextcloud (config.php)..."
  sleep 3
done

# Função auxiliar para rodar comandos como www-data apenas se formos root
run_as_www_data() {
  local cmd="$1"
  if [ "$(id -u)" = "0" ]; then
    # Somos root, então executamos como www-data usando su
    su -p www-data -s /bin/bash -c "$cmd"
  else
    # Já somos www-data ou outro usuário comum, executamos diretamente
    eval "$cmd"
  fi
}

# Instalar/Ativar o app 'user_external'
echo "Instalando/Ativando o aplicativo user_external..."
run_as_www_data "php /var/www/html/occ app:install user_external || php /var/www/html/occ app:enable user_external"

# Configurar o backend IMAP no config.php de forma dinâmica e segura
echo "Configurando as diretivas do servidor IMAP no config.php..."
run_as_www_data 'php -r "
include \"/var/www/html/config/config.php\";

// Define os backends IMAP que queremos configurar
\$backends = [
    [
        \"class\" => \"\\\\OCA\\\\UserExternal\\\\IMAP\",
        \"arguments\" => [
            \"email-ISP\",           // Hostname do contêiner Dovecot
            143,                   // Porta IMAP interna sem SSL
            null,                  // Protocolo (null para sem SSL na rede interna)
            \"nexustech.com.br\",     // Domínio padrão (permite login sem @ para nexustech.com.br)
            false,                 // Não cria diretório home customizado
            true                   // Cria o usuário dinamicamente no Nextcloud ao logar com sucesso
        ]
    ],
    [
        \"class\" => \"\\\\OCA\\\\UserExternal\\\\IMAP\",
        \"arguments\" => [
            \"email-ISP\",           // Hostname do contêiner Dovecot
            143,                   // Porta IMAP interna sem SSL
            null,                  // Protocolo (null para sem SSL na rede interna)
            null,                  // Sem domínio padrão (permite login com e-mail completo para qualquer cliente/domínio)
            false,                 // Não cria diretório home customizado
            true                   // Cria o usuário dinamicamente no Nextcloud ao logar com sucesso
        ]
    ]
];

\$CONFIG[\"user_backends\"] = \$backends;
\$content = \"<?php\n\\\$CONFIG = \" . var_export(\$CONFIG, true) . \";\n\";
file_put_contents(\"/var/www/html/config/config.php\", \$content);
echo \"Múltiplos backends de autenticação IMAP configurados com sucesso no config.php.\n\";
"'

# Garantir permissões de propriedade no config.php se formos root
if [ "$(id -u)" = "0" ]; then
  chown www-data:www-data /var/www/html/config/config.php
fi

echo "=== [NexusTech Setup] Autenticação IMAP configurada com sucesso! ==="
