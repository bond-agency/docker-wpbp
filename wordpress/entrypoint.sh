#!/bin/bash

# mute CMD from official wordpress image entrypoint.
sed -i -e 's/^exec "$@"/#exec "$@"/g' /usr/local/bin/docker-entrypoint.sh

# Run the docker-entrypoint of official wordpress image to do the installation.
bash /usr/local/bin/docker-entrypoint.sh $1

# Update hostname and restart mail tools.
echo "127.0.0.1 $(hostname) localhost localhost.localdomain" >> /etc/hosts
postconf "smtputf8_enable = no"
postfix start

# Wait until the WordPress has been installed.
until wp core version --allow-root; do
  sleep 5;
done;

# Replace the wp-config with our custom extra php.
wp core config \
  --force \
  --allow-root \
  --skip-check \
  --dbname=${WORDPRESS_DB_NAME} \
  --dbuser=root \
  --dbpass=${WORDPRESS_DB_PASSWORD} \
  --dbhost=${WORDPRESS_DB_HOST} \
  --extra-php <<PHP
require_once('/var/www/config/wp-config.php');
PHP

# Fix permissions
usermod -u $USER_ID www-data

# execute CMD
exec "$@"