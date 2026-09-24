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
  - [Pilihan A — OpenCode v1](#pilihan-a--opencode-v1-11832)
  - [Pilihan B — OpenCode v2](#pilihan-b--opencode-v2-2012)
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
| **Mudah dipasang** | Cukup `dpkg -i` satu file |

---

## Prasyarat

Sebelum memulai, pastikan perangkat Anda memenuhi syarat berikut:

| Kebutuhan | Nilai | Cara Cek |
|-----------|-------|----------|
| **Arsitektur** | `aarch64` | `uname -m` |
| **Android** | API ≥ 28 (Android 9+) | — |
| **Termux** | Versi terbaru | `pkg update` |
| **Alat** | `curl`, `dpkg` | `pkg install curl` |

```sh
# Cek arsitektur — harus menampilkan aarch64
uname -m
```

---

## Memilih Versi

Tersedia **dua versi utama** OpenCode. Pilih salah satu sesuai kebutuhan:

| Versi | Perintah | Versi Terbaru | File `.deb` |
|:-----:|:--------:|:-------------:|:------------|
| **v1** | `opencode` | `1.18.32` | `opencode1_1.18.32_aarch64.deb` |
| **v2** | `opencode` | `2.0.12` | `opencode_2.0.12_aarch64.deb` |

| | v1 (1.18.x) | v2 (2.0.x) |
|---|---|---|
| **Status** | Jalur lama | Mainline terbaru |
| **Prefix paket** | `opencode1` | `opencode` |
| **Direkomendasikan** | Untuk kompatibilitas | Untuk umum |

> **Catatan:** v1 dan v2 sama-sama ingin memakai perintah `opencode`.
> Umumnya pasang **salah satu**. Jika ingin keduanya sekaligus, lihat
> [bagian ini](#memasang-v1-dan-v2-berdampingan).

---

## Instalasi

Semua file `.deb` berada di release **Push260922**.

> <https://github.com/Hope2333/opencode-termux/releases/tag/Push260922>

### Pilihan A — OpenCode v1 (1.18.32)

> **Keterangan:** paket v1 memasang binary bernama `opencode1`. Sebuah
> *symlink* dibuat agar bisa dipanggil dengan perintah `opencode`.

```sh
# 1. Unduh
cd ~
curl -fL --retry 3 -o opencode1_1.18.32_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push260922/opencode1_1.18.32_aarch64.deb"

# 2. Periksa isi paket (opsional)
dpkg-deb -I opencode1_1.18.32_aarch64.deb    # metadata paket
dpkg-deb -c opencode1_1.18.32_aarch64.deb    # daftar file di dalam paket

# 3. Install
dpkg -i opencode1_1.18.32_aarch64.deb

# 4. Jadikan perintah `opencode`
ln -sf "$PREFIX/bin/opencode1" "$PREFIX/bin/opencode"

# 5. Verifikasi
opencode --version    # -> 1.18.32

# 6. Bersihkan file installer
rm -f opencode1_1.18.32_aarch64.deb
```

### Pilihan B — OpenCode v2 (2.0.12)

> **Keterangan:** paket v2 memasang binary yang sudah langsung bernama
> `opencode`, tanpa langkah tambahan.

```sh
# 1. Unduh
cd ~
curl -fL --retry 3 -o opencode_2.0.12_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push260922/opencode_2.0.12_aarch64.deb"

# 2. Periksa isi paket (opsional)
dpkg-deb -I opencode_2.0.12_aarch64.deb    # metadata paket
dpkg-deb -c opencode_2.0.12_aarch64.deb    # daftar file di dalam paket

# 3. Install
dpkg -i opencode_2.0.12_aarch64.deb

# 4. Verifikasi
opencode --version    # -> opencode v2.0.12

# 5. Bersihkan file installer
rm -f opencode_2.0.12_aarch64.deb
```

> Versi v2 tersedia dari `2.0.0` sampai `2.0.12`. Untuk versi lain, ganti
> angka `2.0.12` pada nama file di semua perintah dan pada URL, misalnya
> `opencode_2.0.10_aarch64.deb`.

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
> (`dpkg -i`).

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

Jika sebelumnya membuat *symlink* untuk v1, hapus juga:

```sh
rm -f "$PREFIX/bin/opencode"
```

---

## Pemecahan Masalah

### Android 14 ke bawah: `Bad system call` (SIGSYS)

Pada Android ≤ 14, seccomp sistem dapat memblokir syscall `close_range`
(nr 436), sehingga OpenCode mati saat start dengan pesan
*"Bad system call"*. Solusinya memakai shim resmi:

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
dpkg -i --force-conflicts opencode1_1.18.32_aarch64.deb
```

### Memasang v1 dan v2 berdampingan

Kedua versi bisa dipasang bersamaan, tetapi nama perintahnya sama
(`opencode`), sehingga salah satu harus memakai nama berbeda:

| Perintah | Versi | Cara |
|----------|-------|------|
| `opencode` | v2 | Binary bawaan paket |
| `opencode1` | v1 | Tanpa *symlink* `opencode` |

```sh
dpkg -i opencode_2.0.12_aarch64.deb      # v2  -> perintah `opencode`
dpkg -i --force-conflicts opencode1_1.18.32_aarch64.deb   # v1 -> perintah `opencode1`
```

---

## Catatan Teknis

### Keluarga Paket

Repository asli menyediakan beberapa varian paket:

| Keluarga | Package | Keterangan |
|----------|---------|------------|
| native (mainline) | `opencode` / `opencode1` | Zero-glibc bionic ELF, langsung dieksekusi |
| wrapper | `opencode-wrapper` / `opencode1-wrapper` | Wrapper glibc (butuh `glibc` + `openssl-glibc`) |
| compressed (UPX) | `opencode-compressed` / `opencode1-compressed` | UPX `--best`, lebih kecil, startup lebih lambat |
| standalone | `opencode-wrapper-standalone` | Versi beku untuk rollback |

> Panduan ini berfokus pada keluarga **native** (disarankan).

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
