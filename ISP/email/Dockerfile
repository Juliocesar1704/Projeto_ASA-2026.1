FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    bash \
    postfix \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    libsasl2-modules \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY mail.sh /usr/local/bin/mail.sh

RUN chmod +x /usr/local/bin/mail.sh

EXPOSE 25 587 110 143 993 995

CMD ["/usr/local/bin/mail.sh"]