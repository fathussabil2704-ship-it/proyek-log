#!/usr/bin/env bash
# validasi.sh - validasi folder input dan output
# Kode return: 2=input tidak ada, 3=input tidak bisa diakses/terlarang,
#              7=output gagal dibuat, 8=output tidak bisa ditulis

validasi_dir_input() {
    local dir="$1"
    local nama real
    nama="$(basename "$dir")"        # hanya nama folder, supaya path asli tidak masuk log
    real="$(realpath -m "$dir")"     # path absolut untuk pemeriksaan folder terlarang

    if [[ ! -d "$dir" ]]; then
        log ERROR "Direktori input tidak ditemukan: $nama"
        return 2
    fi

    case "$real" in                  # tolak folder sistem
        /|/etc|/etc/*|/root|/root/*|/proc|/proc/*|/sys|/sys/*|/dev|/dev/*|/boot|/boot/*|/var/log|/var/log/*|/home)
            log ERROR "Direktori input ditolak (folder sistem): $nama"
            return 3 ;;
    esac

    if [[ ! -r "$dir" || ! -x "$dir" ]]; then
        log ERROR "Direktori input tidak dapat diakses: $nama"
        return 3
    fi

    return 0
}

validasi_dir_output() {
    local dir="$1"
    local nama
    nama="$(basename "$dir")"

    if [[ ! -d "$dir" ]]; then
        if ! mkdir -p "$dir" 2>/dev/null; then
            log ERROR "Gagal membuat direktori output: $nama"
            return 7
        fi
    fi

    if [[ ! -w "$dir" || ! -x "$dir" ]]; then
        log ERROR "Direktori output tidak dapat ditulisi: $nama"
        return 8
    fi

    return 0
}
