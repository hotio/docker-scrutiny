#!/bin/bash

while true; do
    DEBUG=true "${APP_DIR}/scrutiny-collector-metrics" run --api-endpoint "${2}"
    sleep "${1}"
done
