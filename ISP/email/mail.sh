#!/bin/bash

# Limpar arquivos de PID antigos para evitar travamento em reinicializacoes
rm -f /var/run/rsyslogd.pid /var/run/supervisord.pid /var/run/dovecot/master.pid

# Criar estrutura de diretorios virtuais para cada usuario de email
DOMAIN="nexustech.com.br"
VMAIL_DIR="/var/mail/vhosts/${DOMAIN}"

echo "[mail.sh] Configurando caixas de correio virtuais para ${DOMAIN}..."

mkdir -p "${VMAIL_DIR}"

# Criar diretorios Maildir para cada usuario virtual
for user in admin_nx suporte_nx financeiro_nx contato_nx; do
    mkdir -p "${VMAIL_DIR}/${user}/Maildir/{cur,new,tmp}"
    echo "[mail.sh] Caixa de correio criada: ${user}@${DOMAIN}"
done

chown -R vmail:vmail /var/mail/vhosts

echo "[mail.sh] Configuracao concluida. Supervisor iniciara os servicos."