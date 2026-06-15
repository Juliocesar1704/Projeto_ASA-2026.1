#!/bin/bash

criar_usuario() {
    usuario=$1

    if ! id "$usuario" &>/dev/null; then
        adduser --disabled-password --gecos "" "$usuario"
        echo "$usuario:123456" | chpasswd
        mkdir -p /home/$usuario/Maildir
        chown -R $usuario:$usuario /home/$usuario
        chmod 700 /home/$usuario
        chmod -R 700 /home/$usuario/Maildir
    fi
}

criar_usuario admin_nx
criar_usuario suporte_nx
criar_usuario financeiro_nx
criar_usuario contato_nx