#!/usr/bin/env bash

validasi_dir_input() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        log ERROR "Direktori input tidak ditemukan: $dir"
        return 2
    fi

    if [[ ! -r "$dir" || ! -x "$dir" ]]; then
        log ERROR "Direktori input tidak dapat diakses: $dir"
        return 3
    fi

    return 0
}

validasi_dir_output() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        if ! mkdir -p "$dir"; then
            log ERROR "Gagal membuat direktori output: $dir"
            return 4
        fi
    fi

    if [[ ! -w "$dir" || ! -x "$dir" ]]; then
        log ERROR "Direktori output tidak dapat ditulisi: $dir"
        return 5
    fi

    return 0
}
