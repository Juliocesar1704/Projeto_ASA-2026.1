#!/bin/bash

# --------------------------------------------------
# FUNÇÃO RESPONSÁVEL POR CRIAR USUÁRIOS DE E-MAIL
# --------------------------------------------------

criar_usuario() {

    # Recebe o nome do usuário passado na chamada da função
    usuario=$1

    # Verifica se o usuário já existe no sistema
    # Isso evita erro ao reiniciar o container
    if ! id "$usuario" &>/dev/null; then

        # Cria o usuário:
        # --disabled-password -> não pede senha interativa
        # --gecos "" -> evita perguntas adicionais
        adduser --disabled-password --gecos "" "$usuario"

        # Define a senha padrão do usuário
        echo "$usuario:123456" | chpasswd

        # Cria a estrutura Maildir utilizada pelo Dovecot/Postfix
        mkdir -p /home/$usuario/Maildir

        # Define o usuário como dono da própria pasta
        chown -R $usuario:$usuario /home/$usuario

        # Permissão da home:
        # somente o próprio usuário pode acessar
        chmod 700 /home/$usuario

        # Permissões da caixa de e-mail
        chmod -R 700 /home/$usuario/Maildir

    fi
}

# --------------------------------------------------
# CRIAÇÃO DAS CONTAS DE E-MAIL
# --------------------------------------------------

criar_usuario admin_nx
criar_usuario suporte_nx
criar_usuario financeiro_nx
criar_usuario contato_nx