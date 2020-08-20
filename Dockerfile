FROM golang:1.14.7-alpine3.12 as builder
WORKDIR /src
ENV GO111MODULE=on
COPY . /src
RUN go build -o mtr_exporter main.go && chmod +x mtr_exporter

FROM alpine:3.12
ENTRYPOINT ["/usr/local/bin/mtr_exporter"]
CMD ["-config.file", "/etc/mtr_exporter/config.yml"]
RUN apk add --no-cache mtr
COPY mtr.yaml /etc/mtr_exporter/config.yml
COPY --from=builder /src/mtr_exporter /usr/local/bin/mtr_exporter