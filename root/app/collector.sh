#!/bin/bash

currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${2}" > /dev/null 2>&1) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done

while true; do
    DEBUG=true "${APP_DIR}/scrutiny-collector-metrics" run --api-endpoint "${2}"
    sleep "${1}"
done
