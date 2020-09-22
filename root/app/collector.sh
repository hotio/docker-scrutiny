#!/bin/bash

currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${2}" > /dev/null 2>&1) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done

while true; do
    # shellcheck disable=SC2086
    "${APP_DIR}/scrutiny-collector-metrics" run --api-endpoint "${2}" ${3}
    sleep "${1}"
done
