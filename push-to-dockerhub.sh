#!/bin/bash
# Script to push QloApps image to Docker Hub

set -e

DOCKERHUB_USERNAME="${1:-}"
IMAGE_NAME="qloapps-nomysql-dokku-optimized"

if [ -z "$DOCKERHUB_USERNAME" ]; then
    echo "Usage: $0 <dockerhub-username>"
    echo "Example: $0 myusername"
    exit 1
fi

echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:latest .

echo "Tagging image for Docker Hub..."
docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest

echo "Logging in to Docker Hub..."
docker login

echo "Pushing to Docker Hub..."
docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest

echo ""
echo "✅ Successfully pushed to Docker Hub!"
echo "Image available at: https://hub.docker.com/r/${DOCKERHUB_USERNAME}/${IMAGE_NAME}"
echo ""
echo "To use this image:"
echo "  docker pull ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
echo ""
echo "Or with Dokku:"
echo "  dokku git:from-image qloapps ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"

