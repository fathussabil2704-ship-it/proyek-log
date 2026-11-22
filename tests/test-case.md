# Test Case - Kelompok [02]

| ID uji | Modul/fitur | Kondisi/input | Hasil yang diharapkan | Hasil aktual | Status | Lokasi bukti |
|---|---|---|---|---|---|---|
| TC-01 | Modul 1: pilah log | Folder log simulasi valid | Exit 0; ada ERROR.log, WARN.log, INFO.log, ringkasan.txt | Exit 0. Script menyelesaikan pilah, arsip, dan verifikasi dengan status SUKSES | Lulus | evidence/TC-01.txt |
| TC-02 | Modul 1 (gagal) | Folder input tidak ada | Exit 2; baris ERROR di log | Exit 2. Log mencatat ERROR bahwa direktori input tidak ditemukan | Lulus | evidence/TC-02.txt |
| TC-03 | Modul 2: arsip dan checksum | Arsip utuh | "Checksum cocok"; exit 0 | Exit 0. Checksum arsip cocok | Lulus | evidence/TC-03.txt |
| TC-04 | Modul 2 (gagal) | Salinan arsip diubah | "Checksum TIDAK cocok"; exit 6 | Exit 6. Perubahan pada arsip terdeteksi | Lulus | evidence/TC-04.txt |
| TC-05 | Parameter (gagal) | main.sh tanpa argumen | Pesan pemakaian; exit 1 | Exit 1. Script menampilkan pesan pemakaian | Lulus | evidence/TC-05.txt |
| TC-06 | Integrasi | main.sh dalam container | Dipilah, diarsipkan, diverifikasi; exit 0 | Exit 0. Log: ERROR 2, WARN 2, INFO 2; arsip log-20261122-053021.tar.gz dibuat dan checksum cocok; status SUKSES | Lulus | evidence/docker-run.txt |
| TC-07 | Integrasi (gagal) | Arsip diubah lalu dipulihkan | Terdeteksi exit 6; setelah recovery exit 0 | Sebelum: exit 6. Pemulihan: arsip baru log-20261122-052652.tar.gz dibuat, exit 0. Sesudah: checksum cocok, exit 0 | Lulus | evidence/recovery.txt |
| TC-08 | Akses aman | SCP arsip lalu file terlarang | Diizinkan berhasil; ditolak Permission denied | SCP arsip log-20261122-053315.tar.gz berhasil (100%, 437 byte). SCP uji-akses.txt ditolak: Permission denied. Pembacaan langsung di server juga Permission denied | Lulus | evidence/scp-diizinkan.txt, scp-ditolak.txt, akses-ditolak.txt, permission.txt |
| TC-09 | Persistensi | Hapus lalu buat ulang container | Arsip lama tetap ada | Sebelum: 1 arsip (log-20261122-053021). Setelah container dihapus dan dibuat ulang: 2 arsip (053021 dan 053315). Arsip lama tetap ada | Lulus | evidence/persistensi-sebelum.txt, persistensi-sesudah.txt |
| TC-10 | Resource limit dan monitoring | docker inspect dan docker stats | NanoCpus=500000000; Memory=134217728; stats berupa angka | NanoCpus=500000000, Memory=134217728. Stats: CPU 0,00%, memori 1,602 MiB dari 128 MiB (1,25%), PIDS 1 | Lulus | evidence/limit.txt |
| TC-11 | Keamanan container | Cek privileged dan mount | Privileged=false; input RW=false; tanpa docker.sock | Privileged=false. Mount: /data/input (RW=false), /data/output (RW=true). Tidak ada mount docker.sock | Lulus | evidence/cek-keamanan.txt |
| TC-12 | Validasi input | Folder sistem (/etc) sebagai input | Ditolak; exit 3 | Exit 3. Folder sistem ditolak | Lulus | evidence/TC-12.txt |

Catatan: Hasil aktual hanya diisi dari output asli. Nilai dinamis (waktu, nama arsip) berbeda tiap sistem.
