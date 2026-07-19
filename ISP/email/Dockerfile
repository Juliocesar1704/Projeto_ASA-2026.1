FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    bash \
    postfix \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    dovecot-lmtpd \
    libsasl2-modules \
    ca-certificates \
    openssl \
    supervisor \
    rsyslog && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Criar usuario virtual para mailboxes
RUN groupadd -g 5000 vmail && \
    useradd -u 5000 -g vmail -s /usr/sbin/nologin -d /var/mail/vhosts -m vmail && \
    mkdir -p /var/mail/vhosts/nexustech.com.br && \
    chown -R vmail:vmail /var/mail/vhosts

# Copiar configuracao de autenticacao virtual
COPY dovecot/users /etc/dovecot/users
COPY dovecot/auth-passwdfile.conf.ext /etc/dovecot/conf.d/auth-passwdfile.conf.ext
COPY dovecot/15-mailboxes.conf /etc/dovecot/conf.d/15-mailboxes.conf

COPY mail.sh /usr/local/bin/mail.sh
RUN chmod +x /usr/local/bin/mail.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Executar script de setup antes do supervisor
RUN echo '#!/bin/bash\nbash /usr/local/bin/mail.sh\nexec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 25 587 465 110 143 993 995

CMD ["/usr/local/bin/entrypoint.sh"]