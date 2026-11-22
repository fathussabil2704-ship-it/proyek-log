#!/usr/bin/env bash
# arsip.sh - membuat arsip tar.gz dan checksum SHA-256

buat_arsip() {   # $1=dir terpilah (absolut), $2=dir output (absolut)
  ARSIP="$2/log-$(date +%Y%m%d-%H%M%S).tar.gz"
  tar -czf "$ARSIP" -C "$(dirname "$1")" "$(basename "$1")" \
    || { rm -f "$ARSIP"; log ERROR "tar gagal"; return 4; }
  ( cd "$2" && sha256sum "$(basename "$ARSIP")" > "$(basename "$ARSIP").sha256" ) \
    || { log ERROR "checksum gagal dibuat"; return 5; }
  log INFO "Arsip dibuat: $(basename "$ARSIP")"
}
