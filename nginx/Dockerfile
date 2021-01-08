FROM nginx:1.19.6-alpine-perl

RUN apk add --no-cache nginx-mod-http-perl

COPY /static /static

COPY nginx.conf /etc/nginx/nginx.conf
