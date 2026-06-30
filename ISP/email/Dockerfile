# Dockerfile (Ubuntu 22.04) — para ./email
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y && \
    apt install -y --no-install-recommends \
      postfix \
      dovecot-core \
      dovecot-imapd \
      dovecot-pop3d \
      dovecot-lmtpd \
      mailutils \
      dnsutils \
      netcat-openbsd \
      iputils-ping \
      bash \
      libsasl2-modules \
      sasl2-bin \
      ca-certificates \
      syslog-ng \
      procps \
      nano && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Copiar arquivos do Postfix
COPY ./postfix/main.cf /etc/postfix/main.cf
COPY ./postfix/master.cf /etc/postfix/master.cf
RUN chmod 644 /etc/postfix/main.cf /etc/postfix/master.cf || true

# Remover configs Dovecot padrão
RUN rm -f /etc/dovecot/conf.d/*.conf || true

# Copiar configs Dovecot
COPY ./dovecot/10-*.conf /etc/dovecot/conf.d/
RUN chmod 644 /etc/dovecot/conf.d/10-*.conf || true

# mailname
COPY mailname /etc/mailname

# script de inicialização
COPY mail.sh /usr/local/bin/mail.sh
RUN chmod +x /usr/local/bin/mail.sh

# Criar Maildir padrão em /etc/skel
RUN mkdir -p /etc/skel/Maildir/{cur,new,tmp} && chmod -R 700 /etc/skel/Maildir

# Garantir diretórios de log e spool (sem chown aqui)
RUN mkdir -p /var/log && \
    touch /var/log/mail.log /var/log/dovecot.log && \
    mkdir -p /var/spool/postfix/{active,deferred,maildrop,bounce,defer,flush,incoming,saved,private,public,corrupt}

# Expor portas
EXPOSE 25/tcp 465/tcp 587/tcp 110/tcp 143/tcp 993/tcp 995/tcp

VOLUME ["/var/mail/vmail"]

CMD ["bash", "/usr/local/bin/mail.sh"]
