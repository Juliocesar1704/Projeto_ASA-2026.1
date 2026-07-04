FROM nginx:latest

COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
COPY contato.html /usr/share/nginx/html/
COPY servicos.html /usr/share/nginx/html/
COPY sobre.html /usr/share/nginx/html/

EXPOSE 80