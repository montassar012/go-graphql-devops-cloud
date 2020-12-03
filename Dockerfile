# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang AS build

ENV CGO_ENABLED=0

ENV SRC_DIR=/go/src/go-graphql-app/
WORKDIR $SRC_DIR
# Add the source code:
COPY go.* $SRC_DIR
RUN go mod download
COPY . $SRC_DIR

ARG TARGETOS
ARG TARGETARCH
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/graphql-server .


FROM scratch AS bin
COPY --from=build /out/graphql-server /
COPY --from=build /go/src/go-graphql-app/internal/pkg/db/migrations/mysql /internal/pkg/db/migrations/mysql 



EXPOSE 8080
ENTRYPOINT ["/graphql-server"]
