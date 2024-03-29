FROM golang:1.12 AS builder

RUN mkdir -p /workspace/github.com/uber/makisu
WORKDIR /workspace/github.com/uber/makisu

ADD Makefile .
ADD go.mod ./go.mod
ADD go.sum ./go.sum
RUN make vendor
ADD bin ./bin
ADD lib ./lib
RUN make lbins

FROM alpine
RUN apk add --no-cache libc6-compat

COPY --from=builder /workspace/github.com/uber/makisu/bin/makisu/makisu.linux /makisu-internal/makisu
ADD ./assets/cacerts.pem /makisu-internal/certs/cacerts.pem