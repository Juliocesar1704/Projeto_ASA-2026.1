FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y pdns-server pdns-backend-bind && \
    rm -rf /var/lib/apt/lists/*

COPY pdns.conf /etc/powerdns/pdns.conf

EXPOSE 53/udp 53/tcp

CMD ["pdns_server", "--daemon=no", "--guardian=no", "--loglevel=9"]