FROM nginx:1.19.6-alpine

# RUN apt-get -y update && apt-get install -y systemd sudo && mkdir static

COPY /static /static

COPY nginx.conf /etc/nginx/nginx.conf

# CMD sudo service nginx.service start 
