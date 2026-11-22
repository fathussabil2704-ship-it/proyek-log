#!/usr/bin/env bash
# verifikasi.sh - memeriksa integritas arsip lewat checksum

verifikasi_arsip() {   # $1=path arsip (absolut)
  ( cd "$(dirname "$1")" && sha256sum -c "$(basename "$1").sha256" >/dev/null 2>&1 ) \
    || { log ERROR "Checksum TIDAK COCOK: $(basename "$1")"; return 6; }
  log INFO "Checksum cocok: $(basename "$1")"
}
