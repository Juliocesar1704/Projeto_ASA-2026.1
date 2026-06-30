#!/bin/bash

set -e

echo "[MAIL-ISP] Iniciando configuração do servidor de e-mail..."

# =========================
# Corrigir permissões de configs montadas (se existirem)
# =========================
if [ -f /etc/postfix/main.cf ]; then
  chmod 644 /etc/postfix/main.cf || true
fi
if [ -f /etc/postfix/master.cf ]; then
  chmod 644 /etc/postfix/master.cf || true
fi

# =========================
# Garantir diretórios do Postfix e permissões
# =========================
for dir in active bounce corrupt defer deferred flush incoming saved private maildrop public; do
  mkdir -p /var/spool/postfix/$dir
done

# Ajustar donos e grupos corretos
chown -R postfix:postfix /var/spool/postfix/{active,bounce,corrupt,defer,deferred,flush,incoming,saved,private}
chown -R postfix:postdrop /var/spool/postfix/{maildrop,public}
chmod -R 755 /var/spool/postfix

# =========================
# 1. Iniciar syslog-ng
# =========================
echo "[MAIL-ISP] Iniciando syslog-ng..."
service syslog-ng start || true

# =========================
# 2. Ajuste do Postfix (mensagem)
# =========================
echo "[MAIL-ISP] Postfix configurado."

# =========================
# 3. Criar usuários de teste
# =========================
criar_usuario() {
    usuario=$1
    senha=${2:-123456}

    if ! id "$usuario" >/dev/null 2>&1; then
        echo "[MAIL-ISP] Criando usuário: $usuario"
        useradd -m "$usuario"
        echo "$usuario:$senha" | chpasswd
    fi

    mkdir -p /home/$usuario/Maildir/{cur,new,tmp}
    chown -R $usuario:$usuario /home/$usuario
    chmod -R 700 /home/$usuario/Maildir
    echo "[MAIL-ISP] Usuário $usuario pronto."
}

criar_usuario admin_nx
criar_usuario suporte_nx
criar_usuario financeiro_nx
criar_usuario contato_nx

# =========================
# 4. Garantir permissões Maildir padrão
# =========================
for user in admin_nx suporte_nx financeiro_nx contato_nx; do
    mkdir -p /home/$user/Maildir/{cur,new,tmp}
    chown -R $user:$user /home/$user
    chmod -R 700 /home/$user/Maildir
done

# =========================
# 5. Iniciar serviços na ordem correta
# =========================
echo "[MAIL-ISP] Iniciando Dovecot..."
service dovecot start || true

if ! pgrep dovecot >/dev/null 2>&1; then
    echo "[MAIL-ISP] Dovecot não iniciou via service, tentando modo direto..."
    dovecot || true
fi

# Esperar pelo socket SASL do Dovecot (timeout 20s)
timeout=20
count=0
while [ $count -lt $timeout ]; do
  if [ -S /var/spool/postfix/private/auth ]; then
    echo "[MAIL-ISP] Socket SASL encontrado."
    break
  fi
  sleep 1
  count=$((count+1))
done

if [ $count -ge $timeout ]; then
  echo "[MAIL-ISP] Aviso: socket SASL não encontrado após ${timeout}s. Postfix será iniciado mesmo assim."
fi

echo "[MAIL-ISP] Iniciando Postfix..."
service postfix start || true

# Checagem mais tolerante
sleep 5
if pgrep -x master >/dev/null 2>&1; then
    echo "[MAIL-ISP] Postfix confirmado em execução."
else
    echo "[MAIL-ISP] Aviso: Postfix não foi detectado, verifique logs para detalhes."
fi

echo "[MAIL-ISP] Serviços iniciados com sucesso."

# =========================
# 6. Checagens de configuração
# =========================
echo "[MAIL-ISP] Verificando configuração do Dovecot..."
doveconf -n || echo "[MAIL-ISP] Erro ao validar configuração do Dovecot."

echo "[MAIL-ISP] Verificando configuração do Postfix..."
postfix check || echo "[MAIL-ISP] Erro ao validar configuração do Postfix."

# =========================
# 7. Manter container vivo (logs)
# =========================
tail -F /var/log/mail.log /var/log/dovecot.log || tail -F /var/log/mail.log || sleep infinity
