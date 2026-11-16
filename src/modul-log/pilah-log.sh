#!/usr/bin/env bash
# pilah-log.sh - memilah log per level dan membuat ringkasan

pilah_log() {
    local in="$1"
    local out="$2/terpilah"

    mkdir -p "$out"

    for lv in ERROR WARN INFO; do
        grep -h " $lv" "$in"/*.log > "$out/$lv.log" || true
    done

    {
        echo "RINGKASAN LOG ($(date '+%F %T'))"

        for lv in ERROR WARN INFO; do
            echo "$lv: $(wc -l < "$out/$lv.log")"
        done
    } > "$out/ringkasan.txt"

    log INFO "Pilah selesai: $(tr '\n' ' ' < "$out/ringkasan.txt")"
}
