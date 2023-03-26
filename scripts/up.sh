#!/bin/bash

if [ ! -f docker-compose.ports.yml ]; then
    cp docker-compose.ports.sample.yml docker-compose.ports.yml
fi
docker-compose -f docker-compose.yml -f docker-compose.ports.yml --project-name toluser_api up -d

port=$TOLUSER_API_PORT
if [ -z "$port" ]; then
    port=3001
fi
bundle exec rails s -p $port
