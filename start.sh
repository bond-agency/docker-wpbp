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

status=$(docker-compose ps)

# Check if the containers are already built
if [[ $status == *Up* ]] ; then
  # Nothing to do.
  echo "Already up and running."
  echo "To rebuild the containers use: docker-compose up -d --build"
  exit 0
else
  # Build and start the containers.
  exec docker-compose up -d --build
fi