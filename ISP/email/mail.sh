#!/bin/bash

criar_usuario() {
    usuario=$1

    if ! id "$usuario" >/dev/null 2>&1; then
        useradd -m "$usuario"
        echo "$usuario:123456" | chpasswd
        mkdir -p /home/$usuario/Maildir/{cur,new,tmp}
        chown -R $usuario:$usuario /home/$usuario
    fi
}

criar_usuario admin_nx
criar_usuario suporte_nx
criar_usuario financeiro_nx
criar_usuario contato_nx

service postfix start
service dovecot start

tail -f /dev/null