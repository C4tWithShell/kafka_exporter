FROM golang:1.24.4-alpine3.21 AS build
WORKDIR /application
COPY . ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -gcflags=all=-d=checkptr -ldflags="-w -s -X 'main.version=v1.0.0'" -trimpath \
    -o / ./...

FROM scratch

USER 65534:65534
EXPOSE 9308

ENTRYPOINT [ "/kafka-exporter" ]
COPY --from=build ./kafka-exporter /