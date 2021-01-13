FROM nginx:1.19.6-alpine

ENV STATIC_DIR=/etc/nginx/html

COPY /static ${STATIC_DIR}/static

COPY nginx.conf /etc/nginx/nginx.conf

# EXPOSE 80