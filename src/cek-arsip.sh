#!/usr/bin/env bash
# cek-arsip.sh - memeriksa checksum satu arsip
DIR="$(cd "$(dirname "$0")" && pwd)"
[ $# -eq 1 ] || { echo "Pemakaian: $0 <file-arsip.tar.gz>"; exit 1; }
[ -f "$1" ]  || { echo "Arsip tidak ditemukan: $(basename "$1")"; exit 2; }

ARSIP="$(realpath "$1")"
export LOG_FILE="$(dirname "$ARSIP")/aktivitas.log"
source "$DIR/lib/log.sh"
source "$DIR/modul-arsip/verifikasi.sh"

verifikasi_arsip "$ARSIP"
rc=$?
[ $rc -eq 0 ] && echo "Checksum cocok" || echo "Checksum TIDAK cocok"
exit $rc
