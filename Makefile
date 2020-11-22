lint: 
	hadolint Dockerfile


all: bin/graphql-server

PLATFORM=linux

.PHONY: bin/graphql-server

bin/graphql-server:
	@docker build . --target bin --output type=local,dest=out --platform ${PLATFORM}