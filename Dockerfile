FROM quay.io/prometheus/golang-builder:1.10-base AS build

COPY  . /go/src/github.com/prometheus/blackbox_exporter
WORKDIR /go/src/github.com/prometheus/blackbox_exporter
RUN make promu
RUN make build


FROM quay.io/prometheus/busybox:latest AS release

COPY --from=build /go/src/github.com/prometheus/blackbox_exporter/blackbox-exporter  /bin/blackbox_exporter
COPY --from=build /go/src/github.com/prometheus/blackbox_exporter/blackbox.yml       /etc/blackbox_exporter/config.yml

EXPOSE      9115
ENTRYPOINT  [ "/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
