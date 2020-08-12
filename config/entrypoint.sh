# Main shell script that is run at the time that the Docker image is run
# Go to default.conf directory
#cd /etc/nginx/conf.d;
cd /etc/nginx/sites-available;

# ENV VARS

# A list of environment variables that are passed to the container and their defaults
# DHP - double check that the file exists
export DHP="${DHP:=dhparam.pem}";
if [ -f "/etc/ssl/certs/$DHP" ]
then

    # set pem file in the default file
    sed -i "/ssl_dhparam \//c\\\tssl_dhparam \/etc\/ssl\/certs\/$DHP;" default;
fi

# PEM - double check that the file exists
export PEM="${PEM:=lets-encrypt-x3-cross-signed.pem}";
if [ -f "/etc/nginx/certs/$PEM" ]
then

    # set pem file in the default file
    sed -i "/ssl_trusted_certificate \//c\\\tssl_trusted_certificate \/etc\/nginx\/certs\/$PEM;" default;
fi

# CRT - double check that the file exists
export CRT="${CRT:=nginx-selfsigned.crt}";
if [ -f "/etc/ssl/certs/$CRT" ]
then

    # set crt file in the default file
    sed -i "/ssl_certificate \//c\\\tssl_certificate \/etc\/ssl\/certs\/$CRT;" default;
fi

# KEY - double check that the file exists
export KEY="${KEY:=nginx-selfsigned.key}";
if [ -f "/etc/ssl/private/$KEY" ]
then

    # set key file in the default file
    sed -i "/ssl_certificate_key \//c\\\tssl_certificate_key \/etc\/ssl\/private\/$KEY;" default;
fi

sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" default;
#sed -i s/DOMAIN_NAME/$DOMAIN_NAME/g /etc/nginx/sites-available/default
#cat /etc/nginx/sites-available/default
#exec "$@"

cd /etc/nginx;

# hide server infos
sed -i "s/# server_tokens off;/more_set_headers \"Server: $DOMAIN_NAME\";\n\tserver_tokens off;/g" nginx.conf;

# Needed to make sure nginx is running after the commands are run
nginx -g 'daemon off;'; nginx -s reload;
