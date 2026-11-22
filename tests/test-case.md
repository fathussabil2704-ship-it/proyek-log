# Test Case - Kelompok [XX]

| ID uji | Modul/fitur | Kondisi/input | Hasil yang diharapkan | Hasil aktual | Status | Lokasi bukti |
|---|---|---|---|---|---|---|
| TC-01 | Modul 1: pilah log | Folder log simulasi valid | Exit 0; ada ERROR.log, WARN.log, INFO.log, ringkasan.txt | [isi] | [ ] | evidence/TC-01.txt |
| TC-02 | Modul 1 (gagal) | Folder input tidak ada | Exit 2; baris ERROR di log | [isi] | [ ] | evidence/TC-02.txt |
| TC-03 | Modul 2: arsip dan checksum | Arsip utuh | "Checksum cocok"; exit 0 | [isi] | [ ] | evidence/TC-03.txt |
| TC-04 | Modul 2 (gagal) | Salinan arsip diubah | "Checksum TIDAK cocok"; exit 6 | [isi] | [ ] | evidence/TC-04.txt |
| TC-05 | Parameter (gagal) | main.sh tanpa argumen | Pesan pemakaian; exit 1 | [isi] | [ ] | evidence/TC-05.txt |
| TC-06 | Integrasi | main.sh dalam container | Dipilah, diarsipkan, diverifikasi; exit 0 | [isi] | [ ] | evidence/docker-run.txt |
| TC-07 | Integrasi (gagal) | Arsip diubah lalu dipulihkan | Terdeteksi exit 6; setelah recovery exit 0 | [isi] | [ ] | evidence/recovery.txt |
| TC-08 | Akses aman | SCP arsip lalu file terlarang | Diizinkan berhasil; ditolak Permission denied | [isi] | [ ] | evidence/scp-diizinkan.txt, scp-ditolak.txt, akses-ditolak.txt, permission.txt |
| TC-09 | Persistensi | Hapus lalu buat ulang container | Arsip lama tetap ada | [isi] | [ ] | evidence/persistensi-sebelum.txt, persistensi-sesudah.txt |
| TC-10 | Resource limit dan monitoring | docker inspect dan docker stats | NanoCpus=500000000; Memory=134217728; stats berupa angka | [isi] | [ ] | evidence/limit.txt |
| TC-11 | Keamanan container | Cek privileged dan mount | Privileged=false; input RW=false; tanpa docker.sock | [isi] | [ ] | evidence/cek-keamanan.txt |
| TC-12 | Validasi input | Folder sistem (/etc) sebagai input | Ditolak; exit 3 | [isi] | [ ] | evidence/TC-12.txt |

Catatan: Hasil aktual hanya diisi dari output asli. Nilai dinamis (waktu, nama arsip) berbeda tiap sistem.
