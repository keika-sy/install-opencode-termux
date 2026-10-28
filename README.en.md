<p align="center">
  🌐 <a href="./README.en.md">English</a> | <a href="./README.md">Bahasa Indonesia</a>
</p>

<div align="center">

# OpenCode for Termux

**Install OpenCode on Termux easily and cleanly**

[![GitHub repo size](https://img.shields.io/github/repo-size/keika-sy/install-opencode-termux?style=for-the-badge&color=4B8BBE&label=Repo%20Size)](https://github.com/keika-sy/install-opencode-termux)
[![Platform](https://img.shields.io/badge/Platform-Termux-000000?style=for-the-badge&logo=android&logoColor=white)](https://termux.dev)
[![Architecture](https://img.shields.io/badge/Arch-aarch64-E95420?style=for-the-badge&logo=arm&logoColor=white)](#prerequisites)
[![License](https://img.shields.io/badge/License-MIT-3D9970?style=for-the-badge&logo=open-source-initiative&logoColor=white)](LICENSE)

<br/>

> **Native Bionic Build** — a pure single ELF file, no glibc, no proot, no container.
> Lightweight, fast, and runs natively on Termux.

</div>

---

## Table of Contents

- [About](#about)
- [Prerequisites](#prerequisites)
- [Choosing a Version](#choosing-a-version)
- [Installation](#installation)
  - [Installer Script (Automatic)](#installer-script-automatic)
  - [Option A — OpenCode v1 (1.19.3)](#option-a--opencode-v1-1193)
  - [Option B — OpenCode v2 (2.1.4)](#option-b--opencode-v2-214)
  - [Option C — Software Source (apt / pacman)](#option-c--software-source-apt--pacman)
- [Usage](#usage)
- [Data & Configuration Locations](#data--configuration-locations)
- [Uninstall](#uninstall)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)
- [Technical Notes](#technical-notes)
- [Credits](#credits)

---

## About

This repository provides a **complete installation guide for OpenCode on Termux**.

OpenCode is an AI coding agent that runs in the terminal. For Termux, there is
a dedicated **"native bionic"** build from
[`Hope2333/opencode-termux`](https://github.com/Hope2333/opencode-termux)
that:

| Feature | Description |
|---------|-------------|
| **Zero glibc** | A single Bionic ELF file, no glibc dependency |
| **Built-in TUI** | Full terminal interface via `libopentui.so` |
| **No proot** | No container or chroot needed |
| **Fast** | Directly executed, no wrapper overhead |
| **Easy to install** | Just `dpkg -i` a single file, or use the installer script |

---

## Prerequisites

Before you start, make sure your device meets these requirements:

| Requirement | Value | How to Check |
|-------------|-------|--------------|
| **Architecture** | `aarch64` | `uname -m` |
| **Android** | API ≥ 28 (Android 9+) | — |
| **Termux** | Latest version | `pkg update` |
| **Tools** | `curl`, `dpkg` | `pkg install curl` |
| **Free space** | ~200 MB | — |

```sh
# Check the architecture — it must print aarch64
uname -m
```

---

## Choosing a Version

There are **two main versions** of OpenCode. Pick one that fits your needs:

| Version | Command | Latest Version | `.deb` File |
|:-------:|:-------:|:--------------:|:------------|
| **v1**  | `opencode1` | `1.19.3`      | `opencode1_1.19.3_aarch64.deb` |
| **v2**  | `opencode`  | `2.1.4`      | `opencode_2.1.4_aarch64.deb` |

| | v1 (1.18.x – 1.19.x) | v2 (2.0.x – 2.1.x) |
|---|---|---|
| **Status** | Maintenance line | Current mainline |
| **Package prefix** | `opencode1` | `opencode` |
| **Recommended** | For compatibility | For general use |

**How do they differ in practice?** v2 is OpenCode's current release
series — the newest features and fixes land here, and it is what most
users should install. v1 is the 1.x series, still maintained upstream
for compatibility (e.g. older configurations or workflows that have not
moved to 2.x). So far, upstream's v1 builds stop at **1.19.3** — newer
official OpenCode releases are only built as v2. The two generations
keep their data and configuration fully separate, so switching
generations never erases the other one's settings.

> **Note:** v1 and v2 both want to use the `opencode` command. In general,
> install **one of them**. If you want both at the same time, see
> [this section](#installing-v1-and-v2-side-by-side).

---

## Installation

The `.deb` files for the latest versions are hosted per generation: **v2 in Push261026**, **v1 in Push261016** (the latest version of each generation is not always in the same release).

> v2: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261026>
> v1: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261016>

### Installer Script (Automatic)

The fastest way: use the [`install.sh`](./install.sh) script from this
repository. By default it **always fetches the latest version** of each
generation straight from the GitHub API (auto mode — currently v2:
**2.1.4** in Push261026, v1: **1.19.3** in Push261016; the versions
pinned in the script are only a fallback if the API is unreachable). It
then verifies its **SHA256** against the official `SHA256SUMS.txt`,
installs it with `dpkg -i`, and verifies the result.

**One-liner** (opens the interactive menu — pick an action by number):

```sh
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash
```

#### Interactive menu

Run with **no arguments at all** in a terminal (or with `--menu`), the
script shows a menu like this:

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

(The menu itself is in Indonesian.) Type the number and press Enter.
After an action finishes you return to the menu — so checking for
updates, installing them, and uninstalling can all happen in one
session. The menu reads input straight from the terminal, so it works
with the `curl | bash` one-liner above too.

To skip the menu and install directly (e.g. for automation), pass any
argument — for example `--v2` — or set `OPENCODE_NO_MENU=1`. Without a
terminal (pipe/CI), the script installs v2 directly, as before.

#### How the script works

1. **Environment check** — makes sure the device is `aarch64`, `dpkg`
   is available, and `curl` is installed (it installs curl automatically
   if missing).
2. **Version resolution** — asks the GitHub API for the highest version
   of each generation together with its release tag. If the API is
   unreachable, the script falls back to its pinned versions and tells
   you so.
3. **Download** — the `.deb` is downloaded with a **progress bar that
   adapts to your Termux screen width** (spinner + percent + size +
   estimated time left). Downloads have firm timeouts and are retried
   automatically, so they never hang silently.
4. **SHA256 verification** — the file's checksum is matched against the
   official `SHA256SUMS.txt` from the same release. A mismatch cancels
   the installation.
5. **Install & verify** — `dpkg -i`, then the script runs
   `opencode --version` to prove the result actually works.

No hidden steps: everything the script does is printed as `[INFO]` /
`[ OK ]` / `[WARN]` lines in your terminal.

**Other options:**

```sh
# Install v1 only
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --v1

# Install v1 + v2 side by side
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --both

# Install a specific version from a specific release tag
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --version 2.0.27 --tag Push261013
```

Or download the script first and run it locally:

```sh
curl -fsSL -o install.sh https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh
bash install.sh --help
```

| Option | Description |
|--------|-------------|
| `--menu` | Show the interactive menu (also appears automatically with no arguments in a terminal) |
| `--v2` | Install OpenCode v2 (default) |
| `--v1` | Install OpenCode v1 only (+ `opencode` symlink) |
| `--both` | Install v1 + v2 side by side |
| `--version <ver>` | Install a specific version (adjust `--tag` too) |
| `--tag <tag>` | Force one release tag for all generations (default: per generation) |
| `--no-verify` | Skip SHA256 verification |
| `--force-conflicts` | Pass `--force-conflicts` to `dpkg` |
| `--keep` | Keep the downloaded `.deb` file |
| `--check-update` | Check upstream for the latest version & compare with the installed one |
| `--update` | Update installed packages to the latest version |
| `--uninstall <v1\|v2\|all>` | Uninstall |

**Check for & apply updates:**

```sh
bash install.sh --check-update   # report: installed vs latest version
bash install.sh --update         # download + verify + install the latest version
```

Example `--check-update` output (v2 can be updated, v1 not installed):

```text
Hasil pengecekan — versi terpasang dibandingkan versi terbaru upstream:
  v2   : 2.0.31 -> 2.1.4 (release Push261026) — UPDATE TERSEDIA
  v1   : belum terpasang — versi terbaru 1.19.3 (release Push261016)

[INFO] Ada pembaruan tersedia. Pasang dengan: bash install.sh --update
```

(The script's messages are in Indonesian.) A line reading
`installed -> latest` means an update exists for that generation;
`sudah versi terbaru` means it is already up to date.

> The update check scans the upstream releases list via the GitHub API
> (including *prereleases*, since upstream's newest batches are
> prereleases) and picks the highest version per generation together with
> its release tag.

### Option A — OpenCode v1 (1.19.3)

> **Note:** the v1 package installs a binary named `opencode1`. A symlink is
> created so it can be invoked with the `opencode` command.

```sh
# 1. Download
cd ~
curl -fL --retry 3 -o opencode1_1.19.3_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261016/opencode1_1.19.3_aarch64.deb"

# 2. Verify the checksum (recommended)
curl -fsSL -o SHA256SUMS.txt \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261016/SHA256SUMS.txt"
grep "opencode1_1.19.3_aarch64.deb" SHA256SUMS.txt | sha256sum -c -

# 3. Inspect the package (optional)
dpkg-deb -I opencode1_1.19.3_aarch64.deb    # package metadata
dpkg-deb -c opencode1_1.19.3_aarch64.deb    # list files inside the package

# 4. Install
dpkg -i opencode1_1.19.3_aarch64.deb

# 5. Make it invocable as `opencode`
ln -sf "$PREFIX/bin/opencode1" "$PREFIX/bin/opencode"

# 6. Verify
opencode --version    # -> 1.19.3

# 7. Clean up the installer files
rm -f opencode1_1.19.3_aarch64.deb SHA256SUMS.txt
```

### Option B — OpenCode v2 (2.1.4)

> **Note:** the v2 package ships a binary that is already named `opencode`,
> no extra steps needed.

```sh
# 1. Download
cd ~
curl -fL --retry 3 -o opencode_2.1.4_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261026/opencode_2.1.4_aarch64.deb"

# 2. Verify the checksum (recommended)
curl -fsSL -o SHA256SUMS.txt \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261026/SHA256SUMS.txt"
grep "opencode_2.1.4_aarch64.deb" SHA256SUMS.txt | sha256sum -c -

# 3. Inspect the package (optional)
dpkg-deb -I opencode_2.1.4_aarch64.deb    # package metadata
dpkg-deb -c opencode_2.1.4_aarch64.deb    # list files inside the package

# 4. Install
dpkg -i opencode_2.1.4_aarch64.deb

# 5. Verify
opencode --version    # -> opencode v2.1.4

# 6. Clean up the installer files
rm -f opencode_2.1.4_aarch64.deb SHA256SUMS.txt
```

> v2 versions range from `2.0.0` to `2.1.4`, and v1 from `1.18.8` to
> `1.19.3`. Those versions are spread across several release tags — for a
> version other than the latest, change the **tag** in the URL as well
> (e.g. `2.0.27` lives under the `Push261013` tag), or use the installer
> script with `--version` + `--tag`.

### Option C — Software Source (apt / pacman)

Besides manual install, there is an official package source for
installing/updating via `apt` or `pacman`.

**One-line install** (set up the source and install at once):

```sh
curl -fsSL https://hope2333.github.io/repo/install.sh | sh -s -- --install opencode
```

**Manual via apt:**

```sh
# Add the source (once)
echo "deb [trusted=yes arch=aarch64] https://github.com/Hope2333/opencode-termux/releases/latest/download/ ./" \
  > "$PREFIX/etc/apt/sources.list.d/hope2333.list"

# Install
apt update && apt install opencode          # v2
# or
apt update && apt install opencode1         # v1
```

> The `Packages.gz` index only tracks the **latest version** per package.
> To pin a specific version, use manual installation (`dpkg -i`) or the
> installer script.

---

## Usage

```sh
opencode              # open the TUI (interactive menu)
opencode web          # start the web interface
opencode serve        # start the server
opencode run "..."    # run a single prompt directly (non-interactive)
opencode --version    # print the version
opencode --help       # show help
```

---

## Data & Configuration Locations

| Version | Config | Data |
|---------|--------|------|
| v1 | `~/.config/opencode1` | `~/.local/share/opencode1` |
| v2 | `~/.config/opencode` | `~/.local/share/opencode` |

> Each version keeps its data and configuration **separate**, so they never
> interfere with each other.

---

## Uninstall

```sh
dpkg -r opencode1     # if you installed v1 (Option A)
dpkg -r opencode      # if you installed v2 (Option B)
```

Or via the installer script:

```sh
bash install.sh --uninstall all
```

If you created the symlink for v1, remove it too:

```sh
rm -f "$PREFIX/bin/opencode"
```

> **Note:** uninstalling only removes the package. Data and
> configuration (`~/.config/opencode*`, `~/.local/share/opencode*`) are
> **not** deleted — your history and settings stay safe if you install
> again later. Delete those folders manually for a completely clean
> removal.

---

## Troubleshooting

### Older Android: "Bad system call" (SIGSYS)

On older Android (reported case: Android 12, generally ≤ 14), the system
seccomp policy can block the `close_range` syscall (nr 436), so OpenCode
dies at startup with *"Bad system call"*.

**Good news:** recent native packages ship the
`libopencode-crhandler.so` shim **inside the package**
([issue #36](https://github.com/Hope2333/opencode-termux/issues/36) fix —
older package versions were repacked in the Push261013 release, and all
new versions since Push261016 are hardened). So if you use the latest
version from this guide, the manual steps below are **no longer needed**.

For **old** packages (before that fix), apply the shim manually:

```sh
curl -fsSL https://github.com/Hope2333/opencode-termux/releases/download/native-beta-260826/libopencode-crshim.so \
  -o "$PREFIX/lib/libopencode-crshim.so"

export LD_PRELOAD="$PREFIX/lib/libopencode-crshim.so"
```

To make it permanent, add this to `~/.bashrc` or `~/.profile`:

```sh
export LD_PRELOAD="$PREFIX/lib/libopencode-crshim.so"
```

### Error: "opencode conflicts with opencode1"

Some v2 builds carry `Conflicts: opencode1` metadata. If `dpkg -i` fails with
that message (usually when installing v1), add `--force-conflicts`:

```sh
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb
```

### Downloads fail, stall, or the script seems to hang

The `.deb` download is large (v2 is about 76 MB) and the GitHub API
releases list is about 1–2 MB, so a connection dropping mid-download is
the most common cause of failure. The installer script already handles
this: firm per-attempt timeouts, automatic retries (up to 3), and a
progress bar that shows whether the download is actually moving. If it
still fails:

1. Check your internet connection, then simply run the same script
   again — re-running is safe and will not break an existing install.
2. When installing manually, add `--retry 3` to your `curl` commands.
3. If the GitHub API returns a transient error (rate limit on a shared
   IP address), wait a few minutes and try again.

### Checksum mismatch

This means the downloaded file is **not identical** to the official one
in the release — most often because the download was interrupted or
corrupted. The script cancels the installation for safety. Run it again
to download a fresh copy; do not use `--no-verify` unless you understand
the risk and have checked the file yourself.

### `opencode: command not found` after installing

The package is installed but your shell has not picked up the new
command yet. Close and reopen Termux, or run `hash -r`, then try again.
If you installed **v1 only, manually**, remember its real command is
`opencode1` — the `opencode` command only exists if the symlink was
created (the installer script creates it automatically in `--v1` mode).

### Unsupported architecture / storage full

Upstream packages are only available for **aarch64** — 32-bit (`armv7l`)
or `x86_64` devices cannot use this guide. For storage: the download
plus the installed package needs ~200 MB free; free up space (if
needed, `apt clean` and delete old `.deb` files), then retry.

### Installing v1 and v2 side by side

Both versions can be installed together, but they use the same command name
(`opencode`), so one of them has to use a different name:

| Command | Version | How |
|---------|---------|-----|
| `opencode` | v2 | Binary shipped by the package |
| `opencode1` | v1 | Without the `opencode` symlink |

```sh
dpkg -i opencode_2.1.4_aarch64.deb      # v2  -> command `opencode`
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb   # v1 -> command `opencode1`
```

Or simply run the installer script with `bash install.sh --both`.

---

## FAQ

**Do I need root?**
No. Every step runs as a regular Termux user.

**Does updating erase my configuration and history?**
No. An update only replaces the program package. Configuration, data,
and session history live in `~/.config/opencode*` and
`~/.local/share/opencode*`, separate from the package — the same is
true when uninstalling (see [Uninstall](#uninstall)).

**What is the difference between the script and manual install?**
The end result is identical (the same official `.deb` via `dpkg -i`).
The script automates picking the latest version per generation, the
download, SHA256 verification, installation, and result verification —
the manual route gives you full control over each step.

**Why does SHA256 verification matter?**
A checksum proves the file you downloaded is intact and identical to
what upstream published — not corrupted by an interrupted download, and
not altered by someone else in transit.

**Can I install a specific older version (e.g. to roll back)?**
Yes. Use the script's `--version` + `--tag` (example in the Installer
Script section), or manually download the `.deb` from the matching
release tag. Remember: the latest version of each generation may live
under a different tag.

**Do I need an internet connection?**
Yes, to download the package and check for the latest version. Once
installed, OpenCode itself still needs internet to talk to whichever AI
model provider you use.

**How large is the download?**
The `.deb` packages are tens of MB (v2 2.1.4: about 76 MB), plus a
small checksum file. Keep ~200 MB free so `dpkg` extraction has room
to work.

**Is this guide official from the OpenCode team?**
No — it is a community guide built on Hope2333's Termux build. See
[Credits](#credits).

---

## Technical Notes

### Package Families

The upstream repository provides several package variants:

| Family | Package | Description |
|--------|---------|-------------|
| native (mainline) | `opencode` / `opencode1` | Zero-glibc bionic ELF, directly executable |
| wrapper | `opencode-wrapper` / `opencode1-wrapper` | glibc wrapper (needs `glibc` + `openssl-glibc`) |
| compressed (UPX) | `opencode-compressed` / `opencode1-compressed` | UPX, smaller, slower startup |
| standalone | `opencode-wrapper-standalone` | Frozen version for rollback |

> This guide focuses on the **native** family (recommended). Within one
> generation, the native / wrapper / compressed families are **mutually
> exclusive** — install exactly one. Across generations (`opencode1*`
> with `opencode*`) they may coexist.

### Package Naming History

- `opencode-glibc` → `opencode-wrapper` (renamed, with an automatic upgrade
  path via `Replaces`/`Breaks`).
- v1 packages now use the `opencode1*` prefix so they can coexist with the v2
  `opencode` package on the same device.

---

## Credits

- **OpenCode** — [anomalyco/opencode](https://github.com/anomalyco/opencode)
- **Termux build** — [Hope2333/opencode-termux](https://github.com/Hope2333/opencode-termux)
- **Installation wiki** — [hope2333.github.io](https://hope2333.github.io/wiki/opencode-termux/)

> **Disclaimer:** This repository is a **community installation guide** for
> running OpenCode on Termux. It is **not** built by the OpenCode team, is
> **not affiliated** with the OpenCode team, and is **not endorsed** by them.

<div align="center">

---

Made with ❤️ by [@keika-sy](https://github.com/keika-sy)

</div>
