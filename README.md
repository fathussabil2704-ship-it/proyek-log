# Pengelolaan dan Integritas Arsip Log (SysGuard)
Proyek Akhir Praktikum Sistem Operasi, Pilihan B, Kelompok [XX], Kelas [..]

## 1. Tujuan
Modul 1 memilah log simulasi per level (ERROR, WARN, INFO) dan membuat ringkasan.
Modul 2 mengarsipkan hasil, membuat checksum SHA-256, dan memverifikasi integritas.
Alur: input log -> pilah -> arsip -> checksum -> verifikasi.

## 2. Kebutuhan lingkungan
- Ubuntu Server [versi: cek dengan lsb_release -a]
- Docker [versi: cek dengan docker --version]
- Git, tar, gzip, coreutils (sha256sum)
- Akses internet untuk mengunduh image dasar ubuntu:24.04

## 3. Arsitektur dan pembagian host/container
    HOST                                    CONTAINER
    data/log-simulasi (bind mount, ro) ---> /data/input
    data/hasil        (bind mount, rw) <--> /data/output
    SCP, permission, monitoring              src/main.sh (pilah, arsip, verifikasi)
                                             batas 0,5 CPU dan 128 MB

| Komponen | Host | Container |
|---|---|---|
| Data log dan hasil | Disimpan di host (bind mount) | Dibaca dan ditulis lewat /data |
| Script | Di repository | Di dalam image |
| SCP dan permission | Ya | Tidak |
| Limit dan monitoring | Perintah docker di host | Dibatasi oleh Docker |

## 4. Instalasi
    git clone [URL-REPOSITORY]
    cd proyek-log
    chmod +x src/*.sh
    docker build -t log-arsip:1.0 .

## 5. Menjalankan
Lokal:

    bash src/main.sh data/log-simulasi data/hasil

Docker:

    docker network create log-net
    docker run --name log-proc --network log-net --user "$(id -u):$(id -g)" --cpus 0.5 --memory 128m -v "$PWD/data/log-simulasi:/data/input:ro" -v "$PWD/data/hasil:/data/output" log-arsip:1.0

## 6. Menguji
Lihat tests/test-case.md dan folder evidence/. Contoh:

    bash src/main.sh data/tidak-ada data/hasil ; echo $?     # gagal, exit 2
    bash src/cek-arsip.sh data/hasil/NAMA-ARSIP.tar.gz       # verifikasi checksum

## 7. Memantau

    docker stats --no-stream NAMA-CONTAINER
    docker logs log-proc
    cat data/hasil/aktivitas.log

## 8. Exit status
| Kode | Arti |
|---|---|
| 0 | Sukses |
| 1 | Salah pemakaian (parameter) |
| 2 | Input tidak valid |
| 3 | Output tidak bisa ditulis |
| 4 | Pembuatan arsip gagal |
| 5 | Pembuatan checksum gagal |
| 6 | Checksum tidak cocok (arsip berubah) |

## 9. Akses aman
SCP untuk mengambil arsip dari server. Folder hasil memakai permission 750 dan arsip 640.
Diuji: akses diizinkan berhasil, akses ditolak menghasilkan Permission denied.

## 10. Cleanup dan rollback
Cleanup:

    docker rm log-proc
    docker network rm log-net
    docker rmi log-arsip:1.0
    ls data/hasil            # periksa dulu isinya
    rm -rf data/hasil/*

Rollback: hapus arsip hasil yang rusak lalu jalankan ulang main.sh dari data sumber,
kemudian verifikasi dengan src/cek-arsip.sh.

## 11. Keterbatasan
[Isi jujur, contoh: belum ada jadwal otomatis (cron), belum ada rotasi log,
hanya 3 level log, checksum tidak melindungi jika file .sha256 ikut diubah.]

## 12. Kontribusi
Lihat CONTRIBUTION.md. Commit ID dan tag final ada di Online Text pengumpulan.
