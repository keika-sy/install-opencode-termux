<p align="center">
  🌐 <a href="./README.en.md">English</a> | <a href="./README.md">Bahasa Indonesia</a>
</p>

<div align="center">

# OpenCode for Termux

**Instalasi OpenCode di Termux dengan mudah dan rapi**

[![GitHub repo size](https://img.shields.io/github/repo-size/keika-sy/install-opencode-termux?style=for-the-badge&color=4B8BBE&label=Repo%20Size)](https://github.com/keika-sy/install-opencode-termux)
[![Platform](https://img.shields.io/badge/Platform-Termux-000000?style=for-the-badge&logo=android&logoColor=white)](https://termux.dev)
[![Architecture](https://img.shields.io/badge/Arch-aarch64-E95420?style=for-the-badge&logo=arm&logoColor=white)](#prasyarat)
[![License](https://img.shields.io/badge/License-MIT-3D9970?style=for-the-badge&logo=open-source-initiative&logoColor=white)](LICENSE)

<br/>

> **Native Bionic Build** — satu file ELF murni, tanpa glibc, tanpa proot, tanpa container.
> Ringan, cepat, dan langsung jalan di Termux.

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
- [Catatan Teknis](#catatan-teknis)
- [Kredit](#kredit)

---

## Tentang

Repository ini berisi **panduan lengkap instalasi OpenCode di Termux**.

OpenCode adalah AI coding agent yang berjalan di terminal. Untuk Termux,
tersedia build khusus **"native bionic"** dari
[`Hope2333/opencode-termux`](https://github.com/Hope2333/opencode-termux)
yang:

| Fitur | Keterangan |
|-------|------------|
| **Zero glibc** | Satu file ELF Bionic, tanpa ketergantungan glibc |
| **TUI bawaan** | Antarmuka terminal penuh via `libopentui.so` |
| **Tanpa proot** | Tidak butuh container atau chroot |
| **Cepat** | Langsung dieksekusi, tanpa overhead wrapper |
| **Mudah dipasang** | Cukup `dpkg -i` satu file, atau pakai script installer |

---

## Prasyarat

Sebelum memulai, pastikan perangkat Anda memenuhi syarat berikut:

| Kebutuhan | Nilai | Cara Cek |
|-----------|-------|----------|
| **Arsitektur** | `aarch64` | `uname -m` |
| **Android** | API ≥ 28 (Android 9+) | — |
| **Termux** | Versi terbaru | `pkg update` |
| **Alat** | `curl`, `dpkg` | `pkg install curl` |
| **Ruang kosong** | ± 200 MB | — |

```sh
# Cek arsitektur — harus menampilkan aarch64
uname -m
```

---

## Memilih Versi

Tersedia **dua versi utama** OpenCode. Pilih salah satu sesuai kebutuhan:

| Versi | Perintah | Versi Terbaru | File `.deb` |
|:-----:|:--------:|:-------------:|:------------|
| **v1** | `opencode1` | `1.19.3` | `opencode1_1.19.3_aarch64.deb` |
| **v2** | `opencode` | `2.1.4` | `opencode_2.1.4_aarch64.deb` |

| | v1 (1.18.x – 1.19.x) | v2 (2.0.x) |
|---|---|---|
| **Status** | Jalur pemeliharaan | Mainline terbaru |
| **Prefix paket** | `opencode1` | `opencode` |
| **Direkomendasikan** | Untuk kompatibilitas | Untuk umum |

> **Catatan:** v1 dan v2 sama-sama ingin memakai perintah `opencode`.
> Umumnya pasang **salah satu**. Jika ingin keduanya sekaligus, lihat
> [bagian ini](#memasang-v1-dan-v2-berdampingan).

---

## Instalasi

File `.deb` versi terbaru berada di release per generasi: **v2 di Push261026**, **v1 di Push261016** (versi terbaru tiap generasi tidak selalu berada di release yang sama).

> v2: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261026>
> v1: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261016>

### Script Installer (Otomatis)

Cara tercepat: pakai script [`install.sh`](./install.sh) dari repository
ini. Secara bawaan script **selalu mengambil versi terbaru** tiap
generasi langsung dari GitHub API (mode auto — saat ini v2: **2.1.4** di
Push261026, v1: **1.19.3** di Push261016; pin versi di script hanya
cadangan bila API tidak terjangkau). Script lalu memverifikasi
**SHA256**-nya terhadap `SHA256SUMS.txt` resmi, memasangnya dengan
`dpkg -i`, lalu memverifikasi hasilnya.

**One-liner** (memasang v2 — bawaan):

```sh
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash
```

**Pilihan lain:**

```sh
# Memasang v1 saja
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --v1

# Memasang v1 + v2 berdampingan
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --both

# Memasang versi tertentu dari tag release tertentu
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --version 2.0.27 --tag Push261013
```

Atau unduh dulu script-nya, lalu jalankan secara lokal:

```sh
curl -fsSL -o install.sh https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh
bash install.sh --help
```

| Opsi | Keterangan |
|------|------------|
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

> Cek update memindai daftar releases upstream lewat GitHub API (termasuk
> *prerelease*, karena batch terbaru upstream berstatus prerelease) dan
> mengambil versi tertinggi per generasi beserta tag release-nya.

### Pilihan A — OpenCode v1 (1.19.3)

> **Keterangan:** paket v1 memasang binary bernama `opencode1`. Sebuah
> *symlink* dibuat agar bisa dipanggil dengan perintah `opencode`.

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

> **Keterangan:** paket v2 memasang binary yang sudah langsung bernama
> `opencode`, tanpa langkah tambahan.

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
> untuk versi selain yang terbaru, ganti juga **tag** pada URL
> (misalnya `2.0.27` ada di tag `Push261013`), atau pakai script
> installer dengan opsi `--version` + `--tag`.

### Pilihan C — Software Source (apt / pacman)

Selain instalasi manual, tersedia sumber paket resmi untuk install/update
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

> Indeks `Packages.gz` hanya melacak **versi terbaru** per paket.
> Untuk versi tertentu yang ingin di-*pin*, gunakan instalasi manual
> (`dpkg -i`) atau script installer.

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

> Data dan konfigurasi tiap versi **terpisah**, sehingga tidak saling
> mengganggu.

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

---

## Pemecahan Masalah

### Android lama: `Bad system call` (SIGSYS)

Pada Android lama (kasus yang dilaporkan: Android 12, umumnya ≤ 14),
seccomp sistem dapat memblokir syscall `close_range` (nr 436), sehingga
OpenCode mati saat start dengan pesan *"Bad system call"*.

**Kabar baik:** paket native terbaru sudah membawa shim
`libopencode-crhandler.so` **di dalam paketnya** (perbaikan
[issue #36](https://github.com/Hope2333/opencode-termux/issues/36) —
paket versi lama di-*repack* pada release Push261013, dan semua versi
baru sejak Push261016 sudah ter-*hardening*). Jadi bila Anda memakai
versi terbaru dari panduan ini, langkah manual di bawah **tidak lagi
diperlukan**.

Untuk paket **lama** (sebelum perbaikan itu), solusinya memakai shim
secara manual:

```sh
curl -fsSL https://github.com/Hope2333/opencode-termux/releases/download/native-beta-260826/libopencode-crshim.so \
  -o "$PREFIX/lib/libopencode-crshim.so"

export LD_PRELOAD="$PREFIX/lib/libopencode-crshim.so"
```

Untuk menjadikannya permanen, tambahkan ke `~/.bashrc` atau `~/.profile`:

```sh
export LD_PRELOAD="$PREFIX/lib/libopencode-crshim.so"
```

### Error: "opencode conflicts with opencode1"

Beberapa build v2 membawa metadata `Conflicts: opencode1`. Jika `dpkg -i`
gagal dengan pesan tersebut (umumnya saat memasang v1), tambahkan opsi
`--force-conflicts`:

```sh
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb
```

### Memasang v1 dan v2 berdampingan

Kedua versi bisa dipasang bersamaan, tetapi nama perintahnya sama
(`opencode`), sehingga salah satu harus memakai nama berbeda:

| Perintah | Versi | Cara |
|----------|-------|------|
| `opencode` | v2 | Binary bawaan paket |
| `opencode1` | v1 | Tanpa *symlink* `opencode` |

```sh
dpkg -i opencode_2.1.4_aarch64.deb      # v2  -> perintah `opencode`
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb   # v1 -> perintah `opencode1`
```

Atau cukup jalankan script installer dengan `bash install.sh --both`.

---

## Catatan Teknis

### Keluarga Paket

Repository asli menyediakan beberapa varian paket:

| Keluarga | Package | Keterangan |
|----------|---------|------------|
| native (mainline) | `opencode` / `opencode1` | Zero-glibc bionic ELF, langsung dieksekusi |
| wrapper | `opencode-wrapper` / `opencode1-wrapper` | Wrapper glibc (butuh `glibc` + `openssl-glibc`) |
| compressed (UPX) | `opencode-compressed` / `opencode1-compressed` | UPX, lebih kecil, startup lebih lambat |
| standalone | `opencode-wrapper-standalone` | Versi beku untuk rollback |

> Panduan ini berfokus pada keluarga **native** (disarankan). Dalam satu
> generasi, keluarga native / wrapper / compressed **saling eksklusif**
> — pasang tepat satu. Lintas generasi (`opencode1*` dengan `opencode*`)
> boleh berdampingan.

### Riwayat Perubahan Nama Paket

- `opencode-glibc` → `opencode-wrapper` (rename, dengan jalur upgrade otomatis
  via `Replaces`/`Breaks`).
- Paket v1 kini ber-prefix `opencode1*` agar bisa berdampingan dengan v2
  `opencode` di perangkat yang sama.

---

## Kredit

- **OpenCode** — [anomalyco/opencode](https://github.com/anomalyco/opencode)
- **Build Termux** — [Hope2333/opencode-termux](https://github.com/Hope2333/opencode-termux)
- **Wiki instalasi** — [hope2333.github.io](https://hope2333.github.io/wiki/opencode-termux/)

> **Disclaimer:** Repository ini adalah **panduan instalasi** komunitas untuk
> menghadirkan OpenCode di Termux. Repository ini **bukan** dibuat oleh tim
> OpenCode, **tidak berafiliasi** dengan tim OpenCode, dan tidak didukung
> (*endorsed*) oleh mereka.

<div align="center">

---

Made with ❤️ by [@keika-sy](https://github.com/keika-sy)

</div>
