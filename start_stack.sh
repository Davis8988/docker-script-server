#!/bin/bash

# This script starts the Docker stack using Docker Compose.

# Usage: ./start_stack.sh

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker to continue."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose to continue."
    exit 1
fi


# start the Docker stack
docker-compose up -d
