#!/bin/bash

currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${2}" > /dev/null 2>&1) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done

[[ ${3} == "--debug" ]] && DEBUG="--debug"

while true; do
    "${APP_DIR}/scrutiny-collector-metrics" run --api-endpoint "${DEBUG}"
    sleep "${1}"
done
