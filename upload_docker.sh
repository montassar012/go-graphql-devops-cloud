#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`


dockerpath=mkallali/go-graphql-app:1.0.1
# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login --username=mkallali
docker tag go-graphql-app:latest $dockerpath
# Step 3:
# Push image to a docker repository
docker image push $dockerpath
