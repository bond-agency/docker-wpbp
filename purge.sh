#!/bin/bash

wp_status=$(docker-compose ps wordpress)

if [[ $wp_status == *Up* ]] ; then
  echo "Purging the www-cache..."
  docker-compose exec wordpress bash -c "rm -rf ../cache/*"
  echo "Purge complete"
fi