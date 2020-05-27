FROM alpine:3.11.6 AS stage1
RUN apk --update add bash git && git clone https://github.com/gocardless/amqpc.git

FROM golang:1.14.3-alpine AS stage2
WORKDIR /go/src/github.com/gocardless/amqpc
COPY --from=stage1 /amqpc .
RUN apk --update add bash git && go get && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o amqpc .

FROM alpine:3.11.6 AS stage3
RUN apk --update add bash postgresql-client redis
COPY --from=stage2 /go/src/github.com/gocardless/amqpc/amqpc /usr/local/bin/
ENTRYPOINT ["/bin/bash"]
