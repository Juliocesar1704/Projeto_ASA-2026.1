#!/bin/bash

set -e

echo "[MAIL-ISP] Iniciando configuração do servidor de e-mail..."

# =========================
# 1. Ajuste do Postfix
# =========================

postconf -e "myhostname=nexustech.com.br"
postconf -e "mydomain=nexustech.com.br"
postconf -e "myorigin=\$mydomain"
postconf -e "inet_interfaces=all"
postconf -e "inet_protocols=all"
postconf -e "home_mailbox=Maildir/"
postconf -e "mydestination=\$myhostname, localhost.\$mydomain, localhost, \$mydomain"

echo "[MAIL-ISP] Postfix configurado."

# =========================
# 2. Criar usuários de teste
# =========================

criar_usuario() {
    usuario=$1
    senha=${2:-123456}

    if ! id "$usuario" >/dev/null 2>&1; then
        echo "[MAIL-ISP] Criando usuário: $usuario"

        useradd -m "$usuario"
        echo "$usuario:$senha" | chpasswd

        mkdir -p /home/$usuario/Maildir/{cur,new,tmp}
        chown -R $usuario:$usuario /home/$usuario

        echo "[MAIL-ISP] Usuário $usuario criado com sucesso."
    fi
}

criar_usuario admin_nx
criar_usuario suporte_nx
criar_usuario financeiro_nx
criar_usuario contato_nx

# =========================
# 3. Garantir permissões Maildir padrão
# =========================
for user in admin_nx suporte_nx financeiro_nx contato_nx; do
    mkdir -p /home/$user/Maildir/{cur,new,tmp}
    chown -R $user:$user /home/$user
done

# =========================
# 4. Iniciar serviços corretamente
# =========================

echo "[MAIL-ISP] Iniciando Postfix..."
service postfix start

sleep 2

echo "[MAIL-ISP] Iniciando Dovecot..."
service dovecot start

# fallback caso service falhe
if ! pgrep dovecot >/dev/null; then
    echo "[MAIL-ISP] Dovecot não iniciou via service, tentando modo direto..."
    dovecot
fi

if ! pgrep postfix >/dev/null; then
    echo "[MAIL-ISP] Postfix não iniciou corretamente!"
    exit 1
fi

echo "[MAIL-ISP] Serviços iniciados com sucesso."

# =========================
# 5. Manter container vivo
# =========================

tail -f /var/log/mail.log /dev/null