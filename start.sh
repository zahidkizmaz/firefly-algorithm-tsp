#!/bin/bash

if [ "$1" != "" ]; then
    echo "TSP_FILE=$1" > .env
    docker-compose -f "docker-compose.yml" up
else
    echo "You need to provide file path parameter!"
fi