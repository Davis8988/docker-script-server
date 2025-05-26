#!/bin/bash

# This script builds a Docker image for the application.

# Usage: ./build-image.sh

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker to continue."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose to continue."
    exit 1
fi


# Build the Docker image
docker-compose build
