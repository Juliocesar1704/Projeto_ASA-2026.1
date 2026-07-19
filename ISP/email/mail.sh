#!/bin/bash

# Limpar arquivos de PID antigos para evitar travamento em reinicializacoes
rm -f /var/run/rsyslogd.pid /var/run/supervisord.pid /var/run/dovecot/master.pid

# Gerar certificado SSL autoassinado se nao existir
mkdir -p /etc/ssl/certs /etc/ssl/private
if [ ! -f /etc/ssl/certs/mail.pem ]; then
    echo "[mail.sh] Gerando certificado SSL autoassinado para mail.nexustech.com.br..."
    openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/certs/mail.pem -keyout /etc/ssl/private/mail.key -subj "/CN=mail.nexustech.com.br"
    chmod 644 /etc/ssl/certs/mail.pem
    chmod 600 /etc/ssl/private/mail.key
fi

# Criar estrutura de diretorios virtuais para cada usuario de email
DOMAINS=("nexustech.com.br" "salesfilho.com.br" "cliente2.com.br" "cliente3.com.br")

for DOMAIN in "${DOMAINS[@]}"; do
    VMAIL_DIR="/var/mail/vhosts/${DOMAIN}"
    echo "[mail.sh] Configurando caixas de correio virtuais para ${DOMAIN}..."
    mkdir -p "${VMAIL_DIR}"

    if [ "$DOMAIN" = "nexustech.com.br" ]; then
        USERS=("admin_nx" "suporte_nx" "financeiro_nx" "contato_nx")
    elif [ "$DOMAIN" = "salesfilho.com.br" ]; then
        USERS=("contato" "suporte")
    else
        USERS=("contato")
    fi

    # Criar diretorios Maildir para cada usuario virtual
    for user in "${USERS[@]}"; do
        mkdir -p "${VMAIL_DIR}/${user}/Maildir/{cur,new,tmp}"
        # Criar subpastas padrão IMAP (Sent, Drafts, Trash)
        for folder in Sent Drafts Trash; do
            mkdir -p "${VMAIL_DIR}/${user}/Maildir/.${folder}/{cur,new,tmp}"
        done
        echo "[mail.sh] Caixa de correio criada: ${user}@${DOMAIN}"
    done
done

chown -R vmail:vmail /var/mail/vhosts

echo "[mail.sh] Configuracao concluida. Supervisor iniciara os servicos."