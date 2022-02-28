FROM alpine:3.12.0
ARG arch=x86_64
WORKDIR /usr/local/src/musl-cross-maker/builder
COPY builder /tmp/builder
RUN /tmp/builder/scripts/bootstrap-alpine.sh