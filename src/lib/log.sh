#!/usr/bin/env bash

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp

    timestamp=$(date '+%F %T')

    if [[ -n "${LOG_FILE:-}" ]]; then
        mkdir -p "$(dirname "$LOG_FILE")"
        echo "[$timestamp] $level $message" | tee -a "$LOG_FILE"
    else
        echo "[$timestamp] $level $message"
    fi
}
