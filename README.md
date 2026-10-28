<p align="center">
  🌐 <a href="./README.en.md">English</a> | <a href="./README.md">Bahasa Indonesia</a>
</p>

<div align="center">

# OpenCode for Termux

**Masang OpenCode di Termux, tanpa ribet**

[![GitHub repo size](https://img.shields.io/github/repo-size/keika-sy/install-opencode-termux?style=for-the-badge&color=4B8BBE&label=Repo%20Size)](https://github.com/keika-sy/install-opencode-termux)
[![Platform](https://img.shields.io/badge/Platform-Termux-000000?style=for-the-badge&logo=android&logoColor=white)](https://termux.dev)
[![Architecture](https://img.shields.io/badge/Arch-aarch64-E95420?style=for-the-badge&logo=arm&logoColor=white)](#prasyarat)
[![License](https://img.shields.io/badge/License-MIT-3D9970?style=for-the-badge&logo=open-source-initiative&logoColor=white)](LICENSE)

<br/>

> Build-nya **native bionic** — satu file ELF murni. Nggak pakai glibc,
> nggak pakai proot, nggak pakai container. Makanya ringan dan langsung jalan.

</div>

---

## Daftar Isi

- [Tentang](#tentang)
- [Prasyarat](#prasyarat)
- [Memilih Versi](#memilih-versi)
- [Instalasi](#instalasi)
  - [Script Installer (Otomatis)](#script-installer-otomatis)
  - [Pilihan A — OpenCode v1](#pilihan-a--opencode-v1-1193)
  - [Pilihan B — OpenCode v2](#pilihan-b--opencode-v2-214)
  - [Pilihan C — Software Source](#pilihan-c--software-source-apt--pacman)
- [Cara Penggunaan](#cara-penggunaan)
- [Lokasi Data & Konfigurasi](#lokasi-data--konfigurasi)
- [Uninstall](#uninstall)
- [Pemecahan Masalah](#pemecahan-masalah)
- [Tanya Jawab (FAQ)](#tanya-jawab-faq)
- [Catatan Teknis](#catatan-teknis)
- [Kredit](#kredit)

---

## Tentang

Singkatnya: repo ini isinya cara masang **OpenCode** (AI coding agent yang
jalan di terminal) di **Termux**, lengkap sama script installer-nya.

OpenCode aslinya nggak menyediakan build buat Termux. Untungnya ada
[`Hope2333/opencode-termux`](https://github.com/Hope2333/opencode-termux)
yang bikin build khusus "native bionic", dan panduan ini berdiri di atas
build itu. Kenapa build ini enak:

| Fitur | Keterangan |
|-------|------------|
| **Zero glibc** | Satu file ELF Bionic, nggak ada ketergantungan glibc |
| **TUI bawaan** | Antarmuka terminal penuh via `libopentui.so` |
| **Tanpa proot** | Nggak butuh container atau chroot sama sekali |
| **Cepat** | Dieksekusi langsung, tanpa overhead wrapper |
| **Gampang dipasang** | Tinggal `dpkg -i` satu file, atau pakai script installer |

---

## Prasyarat

Cek dulu HP kamu memenuhi ini:

| Kebutuhan | Nilai | Cara Cek |
|-----------|-------|----------|
| **Arsitektur** | `aarch64` | `uname -m` |
| **Android** | API ≥ 28 (Android 9+) | — |
| **Termux** | Versi terbaru | `pkg update` |
| **Alat** | `curl`, `dpkg` | `pkg install curl` |
| **Ruang kosong** | ± 200 MB | — |

```sh
# Cek arsitektur — keluarnya harus aarch64
uname -m
```

Kalau hasil `uname -m` bukan `aarch64`, berhenti dulu di sini — paketnya
memang cuma tersedia buat arsitektur itu.

---

## Memilih Versi

Ada **dua generasi** OpenCode yang bisa dipasang. Ini ringkasannya:

| Versi | Perintah | Versi Terbaru | File `.deb` |
|:-----:|:--------:|:-------------:|:------------|
| **v1** | `opencode1` | `1.19.3` | `opencode1_1.19.3_aarch64.deb` |
| **v2** | `opencode` | `2.1.4` | `opencode_2.1.4_aarch64.deb` |

| | v1 (1.18.x – 1.19.x) | v2 (2.0.x – 2.1.x) |
|---|---|---|
| **Status** | Jalur pemeliharaan | Mainline terbaru |
| **Prefix paket** | `opencode1` | `opencode` |
| **Cocok buat** | Kompatibilitas | Kebanyakan orang |

Bedanya apa sih? v2 itu seri rilis terbaru OpenCode — fitur dan perbaikan
paling baru masuknya ke sini, jadi buat pemakaian biasa **pilih v2 aja**.
v1 itu seri 1.x yang masih dipelihara upstream buat yang butuh
kompatibilitas (misalnya konfigurasi lama yang belum pindah). Sejauh ini
build v1 upstream mentok di **1.19.3**; rilis OpenCode yang lebih baru dari
itu cuma dibangun sebagai v2. Oh ya, data dan konfigurasi kedua generasi
ini terpisah total, jadi pindah generasi nggak akan menghapus pengaturan
generasi satunya.

> **Satu hal yang perlu tahu:** v1 dan v2 sama-sama pengin pakai perintah
> `opencode`. Normalnya pasang **salah satu aja**. Kalau memang mau
> dua-duanya barengan, caranya ada di
> [bagian ini](#memasang-v1-dan-v2-berdampingan).

> ⚠️ **Pengguna Android 15/16, baca ini dulu:** v2 versi **2.1.4** saat ini
> punya bug yang bikin TUI-nya crash pas dibuka di Android 15/16. Kalau
> HP kamu Android 15/16, pasang **2.0.24** dulu buat jaga-jaga. Detailnya
> ada di [Pemecahan Masalah](#v2-214-crash-di-android-1516-pointer-exceeds-safe-integer-range).

---

## Instalasi

File `.deb` versi terbaru adanya di release per generasi: **v2 di
Push261026**, **v1 di Push261016**. Iya, tag-nya beda — versi terbaru tiap
generasi memang nggak selalu nongol di release yang sama.

> v2: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261026>
> v1: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261016>

### Script Installer (Otomatis)

Cara paling cepat ya pakai script [`install.sh`](./install.sh) dari repo
ini. Kamu tinggal jalanin, script yang mikir: dia nanya GitHub API versi
terbaru tiap generasi itu apa (mode auto — saat ini v2: **2.1.4** di
Push261026, v1: **1.19.3** di Push261016; pin versi di dalam script cuma
cadangan kalau API-nya lagi nggak bisa dihubungi), terus dia unduh
file-nya, cocokkan **SHA256**-nya sama `SHA256SUMS.txt` resmi, pasang
pakai `dpkg -i`, dan terakhir dia buktiin sendiri hasilnya jalan.

**One-liner** (membuka menu interaktif — pilih aksi dengan mengetik angka):

```sh
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash
```

#### Menu interaktif

Dijalankan **tanpa argumen apa pun** di terminal (atau dengan
`--menu`), script menampilkan menu seperti ini:

```text
=== Menu Utama ===
Status terpasang saat ini: v2 = 2.0.31 | v1 = belum terpasang

  1) Pasang OpenCode v2 (versi terbaru)
  2) Pasang OpenCode v1 saja
  3) Pasang v1 + v2 berdampingan
  4) Cek update
  5) Update paket terpasang
  6) Copot pemasangan...
  7) Bantuan
  0) Keluar

Pilih (0-7):
```

Ketik nomornya, tekan Enter. Habis satu aksi selesai, kamu balik lagi ke
menu — jadi cek update, pasang update, sampai copot bisa dilakukan dalam
satu sesi tanpa jalanin script berkali-kali. Menu ini baca input langsung
dari terminal, makanya tetap jalan walaupun script-nya kamu jalankan
lewat one-liner `curl | bash` di atas.

Nggak mau menu? Gampang: kasih argumen apa aja (misalnya `--v2`) dan
script langsung kerja tanpa nanya-nanya. Atau set `OPENCODE_NO_MENU=1`.
Kalau script jalan tanpa terminal (pipe/CI), dia juga otomatis langsung
masang v2 kayak biasa.

#### Cara kerja script

1. **Cek lingkungan** — mastiin perangkatnya `aarch64`, `dpkg` ada, dan
   `curl` terpasang (kalau belum, dia pasang sendiri).
2. **Tentukan versi** — nanya GitHub API: versi tertinggi tiap generasi
   itu apa dan adanya di tag release mana. Kalau API nggak terjangkau,
   dia pakai pin versi bawaannya dan ngasih tahu kamu.
3. **Unduh** — file `.deb` diunduh pakai **progress bar yang ngikutin
   lebar layar** Termux kamu (ada spinner, persen, ukuran, dan perkiraan
   waktu selesai). Unduhannya punya batas waktu yang tegas dan dicoba
   ulang otomatis, jadi nggak bakal menggantung diam-diam.
4. **Verifikasi SHA256** — checksum file dicocokkan sama `SHA256SUMS.txt`
   resmi dari release yang sama. Nggak cocok = pemasangan dibatalkan.
5. **Pasang & verifikasi** — `dpkg -i`, terus script jalanin
   `opencode --version` buat mastiin hasilnya beneran jalan.

Nggak ada langkah siluman: semua yang dia lakukan muncul sebagai baris
`[INFO]` / `[ OK ]` / `[WARN]` di terminal kamu.

**Pilihan lain:**

```sh
# Memasang v1 saja
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --v1

# Memasang v1 + v2 berdampingan
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --both

# Memasang versi tertentu dari tag release tertentu
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --version 2.0.27 --tag Push261013
```

Atau unduh dulu script-nya, baru jalanin lokal:

```sh
curl -fsSL -o install.sh https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh
bash install.sh --help
```

| Opsi | Keterangan |
|------|------------|
| `--menu` | Tampilkan menu interaktif (juga muncul otomatis bila tanpa argumen di terminal) |
| `--v2` | Pasang OpenCode v2 (bawaan) |
| `--v1` | Pasang OpenCode v1 saja (+ symlink `opencode`) |
| `--both` | Pasang v1 + v2 berdampingan |
| `--version <versi>` | Pasang versi tertentu (sesuaikan juga `--tag`) |
| `--tag <tag>` | Paksa satu tag release untuk semua generasi (bawaan: per generasi) |
| `--no-verify` | Lewati verifikasi SHA256 |
| `--force-conflicts` | Teruskan `--force-conflicts` ke `dpkg` |
| `--keep` | Simpan file `.deb` hasil unduhan |
| `--check-update` | Cek versi terbaru di upstream & bandingkan dengan yang terpasang |
| `--update` | Perbarui paket terpasang ke versi terbaru |
| `--uninstall <v1\|v2\|all>` | Copot pemasangan |

**Cek & pasang update:**

```sh
bash install.sh --check-update   # laporan: versi terpasang vs versi terbaru
bash install.sh --update         # unduh + verifikasi + pasang versi terbaru
```

Contoh keluaran `--check-update` (v2 bisa diperbarui, v1 belum terpasang):

```text
Hasil pengecekan — versi terpasang dibandingkan versi terbaru upstream:
  v2   : 2.0.31 -> 2.1.4 (release Push261026) — UPDATE TERSEDIA
  v1   : belum terpasang — versi terbaru 1.19.3 (release Push261016)

[INFO] Ada pembaruan tersedia. Pasang dengan: bash install.sh --update
```

Cara bacanya gampang: baris `terpasang -> terbaru` artinya ada update
buat generasi itu; tulisan `sudah versi terbaru` artinya nggak ada yang
perlu kamu lakukan.

> Soal cek update: script memindai daftar releases upstream lewat GitHub
> API (termasuk *prerelease*, soalnya batch terbaru upstream statusnya
> prerelease) dan ngambil versi tertinggi per generasi beserta tag
> release-nya. Makanya dia nggak gampang ketinggalan versi.

### Pilihan A — OpenCode v1 (1.19.3)

> Paket v1 masang binary bernama `opencode1`. Biar bisa dipanggil pakai
> perintah `opencode` juga, dibuatlah *symlink* (langkah 5 di bawah).
> Script installer ngelakuin langkah ini otomatis.

```sh
# 1. Unduh
cd ~
curl -fL --retry 3 -o opencode1_1.19.3_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261016/opencode1_1.19.3_aarch64.deb"

# 2. Verifikasi checksum (disarankan)
curl -fsSL -o SHA256SUMS.txt \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261016/SHA256SUMS.txt"
grep "opencode1_1.19.3_aarch64.deb" SHA256SUMS.txt | sha256sum -c -

# 3. Periksa isi paket (opsional)
dpkg-deb -I opencode1_1.19.3_aarch64.deb    # metadata paket
dpkg-deb -c opencode1_1.19.3_aarch64.deb    # daftar file di dalam paket

# 4. Install
dpkg -i opencode1_1.19.3_aarch64.deb

# 5. Jadikan perintah `opencode`
ln -sf "$PREFIX/bin/opencode1" "$PREFIX/bin/opencode"

# 6. Verifikasi
opencode --version    # -> 1.19.3

# 7. Bersihkan file installer
rm -f opencode1_1.19.3_aarch64.deb SHA256SUMS.txt
```

### Pilihan B — OpenCode v2 (2.1.4)

> Paket v2 masang binary yang namanya memang sudah `opencode`, jadi
> nggak ada langkah tambahan apa-apa.

```sh
# 1. Unduh
cd ~
curl -fL --retry 3 -o opencode_2.1.4_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261026/opencode_2.1.4_aarch64.deb"

# 2. Verifikasi checksum (disarankan)
curl -fsSL -o SHA256SUMS.txt \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261026/SHA256SUMS.txt"
grep "opencode_2.1.4_aarch64.deb" SHA256SUMS.txt | sha256sum -c -

# 3. Periksa isi paket (opsional)
dpkg-deb -I opencode_2.1.4_aarch64.deb    # metadata paket
dpkg-deb -c opencode_2.1.4_aarch64.deb    # daftar file di dalam paket

# 4. Install
dpkg -i opencode_2.1.4_aarch64.deb

# 5. Verifikasi
opencode --version    # -> opencode v2.1.4

# 6. Bersihkan file installer
rm -f opencode_2.1.4_aarch64.deb SHA256SUMS.txt
```

> Versi v2 tersedia dari `2.0.0` sampai `2.1.4`, dan v1 dari `1.18.8`
> sampai `1.19.3`. Versi-versi itu tersebar di beberapa tag release —
> buat versi selain yang terbaru, ganti juga **tag** pada URL (misalnya
> `2.0.27` ada di tag `Push261013`), atau pakai script installer dengan
> opsi `--version` + `--tag`. Ini juga cara buat *downgrade* — misalnya
> turun ke `2.0.24` gara-gara bug 2.1.4 di Android 15/16.

### Pilihan C — Software Source (apt / pacman)

Selain pasang manual, ada juga sumber paket resmi buat install/update
lewat `apt` atau `pacman`.

**Instalasi satu-baris** (atur source + install sekaligus):

```sh
curl -fsSL https://hope2333.github.io/repo/install.sh | sh -s -- --install opencode
```

**Manual via apt:**

```sh
# Tambahkan source (sekali)
echo "deb [trusted=yes arch=aarch64] https://github.com/Hope2333/opencode-termux/releases/latest/download/ ./" \
  > "$PREFIX/etc/apt/sources.list.d/hope2333.list"

# Install
apt update && apt install opencode          # v2
# atau
apt update && apt install opencode1         # v1
```

> Indeks `Packages.gz` cuma melacak **versi terbaru** per paket. Kalau
> kamu mau *pin* versi tertentu, pakai instalasi manual (`dpkg -i`)
> atau script installer.

---

## Cara Penggunaan

```sh
opencode              # membuka TUI (menu interaktif)
opencode web          # menjalankan antarmuka web
opencode serve        # menjalankan server
opencode run "..."    # menjalankan satu prompt langsung (non-interaktif)
opencode --version    # menampilkan versi
opencode --help       # menampilkan bantuan
```

---

## Lokasi Data & Konfigurasi

| Versi | Konfigurasi | Data |
|-------|-------------|------|
| v1 | `~/.config/opencode1` | `~/.local/share/opencode1` |
| v2 | `~/.config/opencode` | `~/.local/share/opencode` |

Data dan konfigurasi tiap generasi disimpan terpisah, jadi keduanya
nggak bakal saling ganggu. Ini juga alasan kenapa update, downgrade,
bahkan uninstall nggak menghapus pengaturanmu — yang diganti cuma
paket programnya.

---

## Uninstall

```sh
dpkg -r opencode1     # jika memasang v1 (Pilihan A)
dpkg -r opencode      # jika memasang v2 (Pilihan B)
```

Atau lewat script installer:

```sh
bash install.sh --uninstall all
```

Jika sebelumnya membuat *symlink* untuk v1, hapus juga:

```sh
rm -f "$PREFIX/bin/opencode"
```

> **Catatan:** uninstall cuma mencopot paket. Data dan konfigurasi
> (`~/.config/opencode*`, `~/.local/share/opencode*`) **nggak** ikut
> kehapus — riwayat dan pengaturanmu tetap aman kalau suatu saat kamu
> masang lagi. Kalau memang mau bersih total, hapus folder-folder itu
> manual.

---

## Pemecahan Masalah

### v2 2.1.4 crash di Android 15/16: `Pointer exceeds safe integer range`

Kalau `opencode` langsung mati pas dibuka dengan error kayak gini:

```text
Starting background server...
Error: Pointer exceeds safe integer range
    at createContext (...)
    at Tui.run (...)
```

...itu **bug beneran dari upstream**, bukan salah HP kamu dan bukan
salah cara masangnya (`opencode --version` tetap jalan normal — yang
mati cuma TUI-nya). Sudah dilaporkan di
[issue #43](https://github.com/Hope2333/opencode-termux/issues/43) dan
[issue #45](https://github.com/Hope2333/opencode-termux/issues/45).

Akar masalahnya, singkatnya: di Android 15/16, allocator sistem ngasih
tag di byte atas pointer heap, jadi nilai pointernya jadi lebih besar
dari batas aman angka JavaScript. Layer FFI punya OpenTUI (library
TUI-nya OpenCode) nggak siap nerima pointer sebesar itu dan langsung
nyerah. Di Android ≤ 14 masalah ini nggak muncul.

**Solusi sementara: turun ke versi 2.0.24**, yang sudah terbukti jalan
normal di Android 16:

```sh
bash install.sh --version 2.0.24 --tag Push261013
```

Atau unduh manual `opencode_2.0.24_aarch64.deb` dari release
`Push261013` dan `dpkg -i` seperti biasa — paket `.deb` memang bisa
ditimpa versi lama (downgrade itu hal normal di dpkg, datamu nggak
kesentuh). Nanti kalau upstream sudah merilis perbaikan, tinggal
`bash install.sh --update` lagi buat naik ke versi terbaru.

Catatan: mode non-TUI seperti `opencode serve` dan
`opencode run "..."` kemungkinan tetap jalan di 2.1.4 karena crash-nya
ada di jalur TUI, tapi ini belum terverifikasi resmi.

### Android lama: `Bad system call` (SIGSYS)

Di Android lama (kasus yang dilaporkan: Android 12, umumnya ≤ 14),
seccomp sistem bisa memblokir syscall `close_range` (nr 436), jadi
OpenCode mati saat start dengan pesan *"Bad system call"*.

**Kabar baiknya:** paket native terbaru sudah bawa shim
`libopencode-crhandler.so` **di dalam paketnya** (perbaikan
[issue #36](https://github.com/Hope2333/opencode-termux/issues/36) —
paket versi lama di-*repack* pada release Push261013, dan semua versi
baru sejak Push261016 sudah ter-*hardening*). Jadi kalau kamu pakai
versi terbaru dari panduan ini, langkah manual di bawah **nggak perlu
lagi**.

Buat paket **lama** (sebelum perbaikan itu), solusinya pakai shim
secara manual:

```sh
curl -fsSL https://github.com/Hope2333/opencode-termux/releases/download/native-beta-260826/libopencode-crshim.so \
  -o "$PREFIX/lib/libopencode-crshim.so"

export LD_PRELOAD="$PREFIX/lib/libopencode-crshim.so"
```

Biar permanen, tambahkan ke `~/.bashrc` atau `~/.profile`:

```sh
export LD_PRELOAD="$PREFIX/lib/libopencode-crshim.so"
```

### Error: "opencode conflicts with opencode1"

Beberapa build v2 bawa metadata `Conflicts: opencode1`. Kalau `dpkg -i`
gagal dengan pesan itu (biasanya pas masang v1), tambahkan opsi
`--force-conflicts`:

```sh
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb
```

### Unduhan gagal, berhenti, atau script terasa menggantung

Penyebab kegagalan paling umum ya koneksi putus di tengah jalan —
unduhan `.deb` itu besar (v2 sekitar 76 MB) dan daftar releases GitHub
API sekitar 1–2 MB. Script installer sudah ngantisipasi ini: ada batas
waktu per percobaan, percobaannya diulang otomatis sampai 3x, dan
progress bar-nya nunjukin unduhan beneran jalan atau berhenti. Kalau
tetap gagal juga:

1. Cek koneksi internetmu, terus jalanin ulang script yang sama.
   Aman kok diulang — pemasangan yang sudah jadi nggak akan rusak.
2. Kalau pakai cara manual, tambahkan `--retry 3` di perintah `curl`.
3. Kalau GitHub API balas error sesaat (rate limit buat alamat IP
   bersama), tunggu beberapa menit terus coba lagi.

### Checksum tidak cocok

Artinya file yang keunduh **nggak sama** dengan file resmi di release —
penyebab terseringnya unduhan terputus/korup. Script bakal batalin
pemasangan demi keamanan, dan itu memang perilaku yang benar. Jalanin
ulang aja biar file-nya diunduh segar. Jangan pakai `--no-verify`
kecuali kamu paham risikonya dan sudah memeriksa sendiri file-nya.

### `opencode: command not found` setelah pemasangan

Paketnya sih sudah terpasang, tapi shell-nya belum kenal perintah
barunya. Tutup dan buka lagi Termux, atau jalanin `hash -r`, terus
coba lagi. Kalau kamu masang **v1 saja secara manual**, ingat perintah
aslinya itu `opencode1` — perintah `opencode` cuma ada kalau *symlink*
dibuat (script installer bikin otomatis di mode `--v1`).

### Arsitektur tidak didukung / ruang penyimpanan penuh

Paket upstream cuma tersedia buat **aarch64** — perangkat 32-bit
(`armv7l`) atau `x86_64` nggak bisa pakai panduan ini, titik. Soal
ruang: unduhan plus paket terpasang butuh ± 200 MB kosong. Kosongin
dulu (kalau perlu `apt clean` dan hapus file `.deb` lama), terus ulangi.

### Memasang v1 dan v2 berdampingan

Dua-duanya bisa dipasang barengan, tapi nama perintahnya sama-sama
`opencode`, jadi salah satu harus pakai nama berbeda:

| Perintah | Versi | Cara |
|----------|-------|------|
| `opencode` | v2 | Binary bawaan paket |
| `opencode1` | v1 | Tanpa *symlink* `opencode` |

```sh
dpkg -i opencode_2.1.4_aarch64.deb      # v2  -> perintah `opencode`
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb   # v1 -> perintah `opencode1`
```

Atau jalanin aja script installer pakai `bash install.sh --both`.

---

## Tanya Jawab (FAQ)

**Perlu root nggak?**
Nggak. Semua langkah jalan sebagai pengguna Termux biasa.

**Update bakal menghapus konfigurasi dan riwayat saya?**
Nggak. Update (dan downgrade, dan uninstall) cuma mengganti paket
programnya. Konfigurasi, data, dan riwayat sesi tinggal di
`~/.config/opencode*` dan `~/.local/share/opencode*`, terpisah dari
paket — lihat juga [Uninstall](#uninstall).

**Versi mana yang harus saya pasang?**
v2, kecuali kamu punya alasan khusus buat tetap di 1.x. Tapi khusus
pengguna **Android 15/16**: untuk sekarang pasang **2.0.24** dulu,
soalnya 2.1.4 lagi ada bug crash TUI di Android versi itu (detailnya
di Pemecahan Masalah).

**Apa bedanya pasang lewat script sama manual?**
Hasil akhirnya sama persis — paket `.deb` resmi yang sama, dipasang
pakai `dpkg -i` juga. Bedanya, script ngerjain semua langkah bosannya
buat kamu: milih versi terbaru per generasi, unduh, verifikasi SHA256,
masang, terus buktiin hasilnya jalan. Cara manual ngasih kamu kendali
penuh di tiap langkah.

**Kenapa verifikasi SHA256 penting?**
Checksum itu bukti file yang kamu unduh utuh dan identik sama yang
diterbitkan upstream — bukan file rusak gara-gara unduhan putus, dan
bukan file yang diubah pihak lain di tengah jalan.

**Bisa pasang versi lama tertentu (misalnya buat rollback)?**
Bisa banget — paket `.deb` bisa ditimpa versi lama, namanya downgrade
dan itu normal. Pakai `--version` + `--tag` di script (contohnya ada
di bagian Script Installer), atau unduh manual `.deb` dari tag release
yang sesuai. Ingat aja: versi terbaru tiap generasi bisa ada di tag
yang berbeda-beda.

**Harus terhubung ke internet?**
Iya, buat unduh paket dan cek versi terbaru. Sesudah terpasang pun
OpenCode tetap butuh internet buat ngobrol sama penyedia model AI
yang kamu pakai.

**Berapa ukuran yang diunduh?**
Paket `.deb` itu puluhan MB (v2 2.1.4: sekitar 76 MB), ditambah file
checksum kecil. Siapin ruang kosong ± 200 MB biar proses ekstraksi
`dpkg` leluasa.

**Panduan ini resmi dari tim OpenCode?**
Bukan — ini panduan komunitas yang berdiri di atas build Termux dari
Hope2333. Lihat [Kredit](#kredit).

---

## Catatan Teknis

### Keluarga Paket

Repo aslinya menyediakan beberapa varian paket:

| Keluarga | Package | Keterangan |
|----------|---------|------------|
| native (mainline) | `opencode` / `opencode1` | Zero-glibc bionic ELF, langsung dieksekusi |
| wrapper | `opencode-wrapper` / `opencode1-wrapper` | Wrapper glibc (butuh `glibc` + `openssl-glibc`) |
| compressed (UPX) | `opencode-compressed` / `opencode1-compressed` | UPX, lebih kecil, startup lebih lambat |
| standalone | `opencode-wrapper-standalone` | Versi beku untuk rollback |

> Panduan ini fokus ke keluarga **native** (yang disarankan). Dalam
> satu generasi, keluarga native / wrapper / compressed itu **saling
> eksklusif** — pasang tepat satu. Lintas generasi (`opencode1*` sama
> `opencode*`) boleh berdampingan.

### Riwayat Perubahan Nama Paket

- `opencode-glibc` → `opencode-wrapper` (diganti nama, dengan jalur upgrade otomatis
  via `Replaces`/`Breaks`).
- Paket v1 sekarang ber-prefix `opencode1*` biar bisa berdampingan dengan v2
  `opencode` di perangkat yang sama.

---

## Kredit

- **OpenCode** — [anomalyco/opencode](https://github.com/anomalyco/opencode)
- **Build Termux** — [Hope2333/opencode-termux](https://github.com/Hope2333/opencode-termux)
- **Wiki instalasi** — [hope2333.github.io](https://hope2333.github.io/wiki/opencode-termux/)

> **Disclaimer:** Repo ini **panduan instalasi** komunitas buat
> menghadirkan OpenCode di Termux. Repo ini **bukan** buatan tim
> OpenCode, **nggak berafiliasi** dengan tim OpenCode, dan nggak
> didukung (*endorsed*) oleh mereka.

<div align="center">

---

Made with ❤️ by [@keika-sy](https://github.com/keika-sy)

</div>
