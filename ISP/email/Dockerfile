FROM ubuntu:22.04

# Evita perguntas interativas durante instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualização e instalação dos serviços
RUN apt update -y && apt upgrade -y && \
    apt install -y \
    postfix \
    dovecot-imapd \
    dovecot-pop3d \
    dovecot-lmtpd \
    telnet \
    nano \
    syslog-ng \
    procps \
    net-tools && \
    apt clean

# --------------------------------------------------
# POSTFIX
# --------------------------------------------------

COPY ./postfix/ /etc/postfix/
COPY mailname /etc/mailname

# Corrige permissões do Postfix
RUN chmod 644 /etc/postfix/main.cf && \
    chown root:root /etc/postfix/main.cf

# --------------------------------------------------
# DOVECOT
# --------------------------------------------------

# Remove configs padrão
RUN rm -f /etc/dovecot/conf.d/*.conf

# Copia configs personalizadas
COPY ./dovecot/ /etc/dovecot/conf.d/

# --------------------------------------------------
# SCRIPT DE USUÁRIOS
# --------------------------------------------------

COPY mail.sh /usr/local/bin/mail.sh

RUN chmod +x /usr/local/bin/mail.sh

# --------------------------------------------------
# ESTRUTURA PADRÃO DOS E-MAILS
# --------------------------------------------------

# Todo novo usuário já nasce com Maildir
RUN mkdir -p /etc/skel/Maildir/{cur,new,tmp}

# Permissões do Maildir
RUN chmod -R 700 /etc/skel/Maildir

# --------------------------------------------------
# PORTAS
# --------------------------------------------------

# SMTP
EXPOSE 25/tcp

# SUBMISSION
EXPOSE 587/tcp

# POP3
EXPOSE 110/tcp

# IMAP
EXPOSE 143/tcp

# IMAPS
EXPOSE 993/tcp

# POP3S
EXPOSE 995/tcp

# --------------------------------------------------
# PERSISTÊNCIA
# --------------------------------------------------

# Salva usuários e e-mails fora do container
VOLUME ["/home"]

# --------------------------------------------------
# INICIALIZAÇÃO
# --------------------------------------------------

CMD ["sh", "-c", "\
/usr/local/bin/mail.sh && \
service syslog-ng start && \
service postfix start && \
service dovecot start && \
tail -F /var/log/mail.log \
"]