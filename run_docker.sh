#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Step 1:
# Build image and add a descriptive tag
#As we are leveraging BuildKit, we will need to make sure that we enable it by using Docker 19.03 or later and setting DOCKER_BUILDKIT=1 in our environment. On Linux, macOS, or using WSL 2 we can do this using the following command:
export DOCKER_BUILDKIT=1


docker build --tag go-graphql-app .   
# Step 2: 
# List docker images
docker images 
# Step 3: 
# Run go-graphql app
docker run -p 8080:8080 --rm --name go-graphql-app -e DB_HOST=host.docker.internal  go-graphql-app