FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    netcat-openbsd \
    dnsutils \
    iputils-ping \
    telnet \
    bash \
    postfix \
    mailutils \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    libsasl2-modules \
    sasl2-bin \
    ed \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


COPY ./dovecot/ /etc/dovecot/conf.d/
COPY ./postfix/ /etc/postfix

COPY mail.sh /usr/local/bin/mail.sh
RUN chmod +x /usr/local/bin/mail.sh

RUN mkdir -p /etc/skel/Maildir/{cur,new,tmp} && chmod -R 700 /etc/skel/Maildir


EXPOSE 25 587 110 143 993 995

CMD ["bash", "/usr/local/bin/mail.sh"]