#!/bin/bash

# Default .env filename if not given as parameter
default=".env.development"

# Check if the .env filename was given as first argument?
if [ -z "$1" ]; then
  # Ask which .env file to use
  read -p "What .env file to use? [$default]: " env_file
  env_file=${env_file:-$default}
else
  env_file=$1
fi

# Check if that file exists and source it
if [ ! -f $env_file ]; then
  echo "No .env file named '$env_file' found!"
  exit 1
else
  # Source the .env file
  source $env_file
fi

# Check that the required environment variables are set
[ -z "$WPTB_ENV" ] && echo "You need to set WPTB_ENV" && exit 1;
[ -z "$NGINX_ENV" ] && echo "You need to set NGINX_ENV" && exit 1;
[ -z "$VIRTUAL_HOST" ] && echo "You need to set VIRTUAL_HOST" && exit 1;
[ -z "$WORDPRESS_DB_PASSWORD" ] && echo "You need to set WORDPRESS_DB_PASSWORD" && exit 1;
[ -z "$HOSTNAME" ] && echo "You need to set HOSTNAME" && exit 1;

# Print disclaimer about denerated file.
echo "Building docker-compose.yml ..."
echo "#############################################################" > "docker-compose.yml"
echo "# THIS IS AUTOMATICALLY GENERATED FILE. DO NOT MODIFY THIS! #" >> "docker-compose.yml"
echo "#############################################################" >> "docker-compose.yml"

# Generate the content of docker-compose.yml from our config.
envsubst < "config.yml" >> "docker-compose.yml"

status=$(docker-compose ps)

# Check if the containers are already built
if [[ $status == *Up* ]] ; then
  # Nothing to do.
  echo " "
  echo "Containers already up and running."
  echo "To rebuild the containers use: source $env_file && docker-compose up -d --build"
  exit 0
else
  # Build and start the containers.
  docker-compose up -d --build
fi