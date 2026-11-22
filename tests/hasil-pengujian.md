# Hasil Pengujian - Kelompok [02]

Tanggal: 22/10/2026   Sistem: Ubuntu Server kelas

## Interpretasi

### TC-04: arsip yang diubah terdeteksi (exit 6)
**Data menunjukkan:** `cek-arsip.sh` pada salinan arsip yang sengaja diubah menampilkan "Checksum TIDAK cocok" dan exit status [6] (evidence/TC-04.txt). Pada arsip utuh (TC-03) hasilnya "Checksum cocok" dan exit status [0].

**Mengapa muncul:** SHA-256 dihitung dari seluruh isi arsip, sehingga perubahan satu karakter menghasilkan nilai yang sama sekali berbeda. Fungsi `verifikasi_arsip` menjalankan `sha256sum -c` yang membandingkan nilai hasil hitung dengan nilai yang tersimpan di file `.sha256`. Karena tidak sama, fungsi mengembalikan kode 6.

**Keputusan yang dapat diambil:** arsip dengan exit 6 dianggap tidak dapat dipercaya dan tidak dipakai. Arsip dibuat ulang dari data sumber (lihat bagian recovery).

**Risiko jika salah tafsir:** (1) exit 6 hanya menunjukkan bahwa arsip berubah, bukan apa yang berubah, kapan, atau oleh siapa. (2) Jika file `.sha256` ikut diganti bersama arsipnya, pemeriksaan tetap lolos sehingga memberi rasa aman yang palsu. (3) Exit 0 hanya berarti arsip sama dengan checksum-nya, bukan bahwa isi log benar.

**Pemeriksaan tambahan:** menyimpan checksum di lokasi terpisah dari arsip, atau membandingkan dengan salinan di backup.

### TC-09: data tetap ada setelah container dibuat ulang
**Data menunjukkan:** sebelum container dihapus, `data/hasil` berisi arsip (evidence/persistensi-sebelum.txt). Setelah container dihapus dan dibuat ulang, daftar berisi arsip lama ditambah arsip baru (evidence/persistensi-sesudah.txt).

**Mengapa muncul:** hasil ditulis ke `/data/output` di dalam container, yang merupakan bind mount ke folder `data/hasil` di host. Lapisan tulis milik container hilang saat `docker rm`, tetapi folder di host tidak ikut terhapus.

**Keputusan yang dapat diambil:** data yang harus bertahan ditaruh di bind mount atau volume, bukan di dalam filesystem container.

**Risiko jika salah tafsir:** tanpa mount, hasil hilang bersama container. Sebaliknya, mount yang dapat ditulis memberi container akses tulis ke folder host, karena itu input dipasang read-only (`:ro`) dan container dijalankan sebagai user biasa, bukan root.

**Pemeriksaan tambahan:** memverifikasi arsip lama masih utuh dengan `cek-arsip.sh`, bukan hanya melihat namanya di daftar.

### TC-10: batas CPU dan memori
**Data menunjukkan:** `docker inspect` menampilkan NanoCpus=[500000000] dan Memory=[134217728]. `docker stats` menampilkan pemakaian memori 1,602 MiB dari batas 128 MiB (1,25%) dan pemakaian CPU 0,00% (evidence/limit.txt).

**Mengapa muncul:** NanoCpus dihitung dalam miliar-an CPU, jadi 500000000 berarti 0,5 CPU. Memory dalam byte, jadi 134217728 sama dengan 128 x 1024 x 1024 byte atau 128 MiB, sesuai opsi `--cpus 0.5` dan `--memory 128m`. Container `log-mon` dipakai untuk menampilkan `docker stats` karena container pemroses cepat selesai sehingga tidak sempat dipantau.

**Keputusan yang dapat diambil:** batas sumber daya sudah terpasang pada container sesuai konfigurasi.

**Risiko jika salah tafsir:** nilai konfigurasi yang terpasang belum membuktikan batas itu ditegakkan saat beban tinggi. Satu snapshot `docker stats` hanya menggambarkan satu saat, dan proses `sleep` hampir tidak memakai CPU, sehingga batas CPU tidak terlihat bekerja. Jika memori melebihi batas, container dapat dihentikan oleh sistem.

**Pemeriksaan tambahan:** menjalankan proses yang benar-benar memakai CPU dan memori untuk melihat batas bekerja.

### TC-08: akses diizinkan dan ditolak
**Data menunjukkan:** `scp` arsip berhasil (evidence/scp-diizinkan.txt), sedangkan `scp` file `uji-akses.txt` menghasilkan "Permission denied" (evidence/scp-ditolak.txt). File uji dibuat dengan mode 000 (evidence/akses-ditolak.txt) dan arsip memakai mode 640 (evidence/permission.txt).

**Mengapa muncul:** login SCP berhasil pada kedua percobaan. Perbedaannya ada di izin file: arsip dapat dibaca oleh pemiliknya (mode 640), sedangkan mode 000 mencabut semua izin, termasuk dari pemilik, sehingga pembacaan ditolak.

**Keputusan yang dapat diambil:** akses file ke arsip dikendalikan lewat permission, dengan file hasil tidak dapat dibaca oleh pengguna yang tidak berhak.

**Risiko jika salah tafsir:** pengujian dengan akun root tidak akan menghasilkan penolakan karena root melewati pemeriksaan izin. Penolakan pada file bermode 000 juga belum membuktikan bahwa pengguna lain (kategori "others") tidak dapat membaca arsip bermode 640.

**Pemeriksaan tambahan:** mencoba membaca arsip dari akun pengguna lain, jika tersedia.

## Kondisi gagal dan recovery
Pada evidence/recovery.txt, arsip salinan yang rusak menghasilkan exit [6] (sebelum). Pemulihannya dilakukan dengan menghapus salinan yang rusak lalu menjalankan ulang `main.sh` dari data sumber, yang menghasilkan arsip baru dengan exit [0]. Verifikasi sesudahnya menghasilkan exit [0].

Recovery di sini berarti membuat ulang arsip, bukan memperbaiki arsip yang rusak. Cara ini hanya berhasil selama data sumber (`data/log-simulasi`) masih utuh.
