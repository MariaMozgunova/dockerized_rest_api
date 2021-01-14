FROM nginx:1.19.6-alpine

ENV ROOT=/etc/nginx/html

COPY /static ${ROOT}/static

COPY nginx.conf /etc/nginx/nginx.conf

# EXPOSE 80