FROM nginx:latest

RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/
COPY assets /usr/share/nginx/html/assets
COPY pages /usr/share/nginx/html/pages

EXPOSE 80