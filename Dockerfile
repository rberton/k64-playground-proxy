# BASE
FROM ubuntu:18.04

LABEL Maintainer="Romain Berton <romain.berton.dev@gmail.com>"

# RUN
RUN apt-get update; \
    apt-get install --no-install-recommends --no-install-suggests -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    # git \
    libssl-dev \
    nginx \
    nginx-extras \
    openssl; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /run/nginx/; \
    mkdir /etc/nginx/certs; \
    touch /etc/nginx/certs/dhparam.pem; \
    openssl dhparam 2048 -out /etc/nginx/certs/dhparam.pem; \
    useradd -ms /bin/bash k64; \
    usermod -aG sudo k64; \
    mkdir /home/k64/logs;

WORKDIR /home/k64

# CONFIGURATIONS

# nginx configuration
COPY $PWD/config/default.conf /etc/nginx/sites-available/default

# keys and certs
COPY $PWD/config/nginx-selfsigned.key /etc/ssl/private/
COPY $PWD/config/nginx-selfsigned.crt /etc/ssl/certs/
COPY $PWD/config/dhparam.pem /etc/ssl/certs/
COPY $PWD/config/lets-encrypt-x3-cross-signed.pem /etc/nginx/certs/

# custom errors
COPY $PWD/config/50*.html /usr/share/nginx/html/
COPY $PWD/config/404.html /usr/share/nginx/html/

# ENTRYPOINT
COPY $PWD/config/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]

# EXPOSE PORTS
EXPOSE 80 443

# RUN COMMAND
CMD ["/bin/sh", "-c", "nginx -g 'daemon off;'; nginx -s reload;"]
