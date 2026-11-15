
#!/usr/bin/env bash
# main.sh - pilah log, arsipkan, lalu verifikasi checksum

DIR="$(cd "$(dirname "$0")" && pwd)"

[ $# -eq 2 ] || {
    echo "Pemakaian: $0 <dir-log-input> <dir-output>"
    exit 1
}

IN="$(realpath -m "$1")"
OUT="$(realpath -m "$2")"

export LOG_FILE="$OUT/aktivitas.log"

source "$DIR/lib/log.sh"
source "$DIR/lib/validasi.sh"
source "$DIR/modul-log/pilah-log.sh"
source "$DIR/modul-arsip/arsip.sh"
source "$DIR/modul-arsip/verifikasi.sh"

log INFO "START input=$IN output=$OUT"

validasi_dir_input "$IN" || exit $?
validasi_dir_output "$OUT" || exit $?

pilah_log "$IN" "$OUT"

buat_arsip "$OUT/terpilah" "$OUT" || exit $?
verifikasi_arsip "$ARSIP" || exit $?

log INFO "SELESAI status=SUKSES"
echo "Berhasil: $ARSIP"

exit 0
