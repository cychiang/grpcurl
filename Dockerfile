FROM golang:1.10.3-alpine3.7 as builder
RUN apk add --no-cache git gcc make musl-dev bash

ENV PROJ github.com/networld-to/grpcurl
ENV PROJ_DIR /go/src/${PROJ}

WORKDIR ${PROJ_DIR}
COPY . .

RUN make deps install
RUN ls /go/bin/grpcurl

#####################################################
# Final, minimized docker image usable in production
#####################################################
FROM alpine:3.7
ADD https://curl.haxx.se/ca/cacert.pem /etc/ssl/certs/ca-certificates.crt
RUN apk add --no-cache curl
COPY --from=builder /go/bin/grpcurl /
