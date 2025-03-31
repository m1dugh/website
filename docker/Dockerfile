FROM debian:12-slim AS builder

ARG HUGO_VERSION=0.136.5

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y \
        wget \
        ca-certificates

RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb -O /opt/hugo.deb && \
    dpkg -i /opt/hugo.deb

COPY ./hugo /build/hugo

WORKDIR /build/hugo

RUN --mount=type=cache,dst=/cache \
    hugo build \
        --cacheDir "/cache" \
        -d /build/public

FROM nginx:1.27.4-alpine3.21

COPY --from=builder /build/public /usr/share/nginx/html
