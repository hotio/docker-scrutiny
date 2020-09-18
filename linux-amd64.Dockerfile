FROM golang:alpine as builder

ARG VERSION

RUN apk add --no-cache git gcc musl-dev nodejs npm && \
    git clone -n https://github.com/AnalogJ/scrutiny.git /scrutiny && cd /scrutiny && \
    git checkout ${VERSION} -b hotio && \
    go mod vendor && \
    go build -ldflags '-w -extldflags "-static"' -o scrutiny webapp/backend/cmd/scrutiny/scrutiny.go && \
    go build -ldflags '-w -extldflags "-static"' -o scrutiny-collector-selftest collector/cmd/collector-selftest/collector-selftest.go && \
    go build -ldflags '-w -extldflags "-static"' -o scrutiny-collector-metrics collector/cmd/collector-metrics/collector-metrics.go && \
    chmod 755 "/scrutiny/scrutiny" && \
    chmod 755 "/scrutiny/scrutiny-collector-selftest" && \
    chmod 755 "/scrutiny/scrutiny-collector-metrics" && \
    cd /scrutiny/webapp/frontend && \
    mkdir /scrutiny-web && \
    npm install && \
    npx ng build --output-path=/scrutiny-web --deploy-url="/web/" --base-href="/web/" --prod

FROM hotio/base@sha256:ba659a30bf39b06d1e9bd5f7c792861f20d8d1e68ce46434680066f52afc2e6f
EXPOSE 8080
ENV SCRUTINY_INTERVAL=86400 SCRUTINY_API_ENDPOINT="http://localhost:8080" SCRUTINY_MODE="BOTH"
RUN apk add --no-cache smartmontools && \
    mkdir -p /scrutiny/config && \
    ln -s "${CONFIG_DIR}/app/scrutiny.yaml" /scrutiny/config/scrutiny.yaml
COPY --from=builder /scrutiny/scrutiny ${APP_DIR}/
COPY --from=builder /scrutiny/scrutiny-collector-selftest ${APP_DIR}/
COPY --from=builder /scrutiny/scrutiny-collector-metrics ${APP_DIR}/
COPY --from=builder /scrutiny-web ${APP_DIR}/
COPY root/ /
