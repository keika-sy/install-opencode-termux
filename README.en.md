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
  - [Option A — OpenCode v1 (1.18.32)](#option-a--opencode-v1-11832)
  - [Option B — OpenCode v2 (2.0.12)](#option-b--opencode-v2-2012)
  - [Option C — Software Source (apt / pacman)](#option-c--software-source-apt--pacman)
- [Usage](#usage)
- [Data & Configuration Locations](#data--configuration-locations)
- [Uninstall](#uninstall)
- [Troubleshooting](#troubleshooting)
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
| **Easy to install** | Just `dpkg -i` a single file |

---

## Prerequisites

Before you start, make sure your device meets these requirements:

| Requirement | Value | How to Check |
|-------------|-------|--------------|
| **Architecture** | `aarch64` | `uname -m` |
| **Android** | API ≥ 28 (Android 9+) | — |
| **Termux** | Latest version | `pkg update` |
| **Tools** | `curl`, `dpkg` | `pkg install curl` |

```sh
# Check the architecture — it must print aarch64
uname -m
```

---

## Choosing a Version

There are **two main versions** of OpenCode. Pick one that fits your needs:

| Version | Command | Latest Version | `.deb` File |
|:-------:|:-------:|:--------------:|:------------|
| **v1**  | `opencode` | `1.18.32`      | `opencode1_1.18.32_aarch64.deb` |
| **v2**  | `opencode` | `2.0.12`       | `opencode_2.0.12_aarch64.deb` |

| | v1 (1.18.x) | v2 (2.0.x) |
|---|---|---|
| **Status** | Legacy line | Current mainline |
| **Package prefix** | `opencode1` | `opencode` |
| **Recommended** | For compatibility | For general use |

> **Note:** v1 and v2 both want to use the `opencode` command. In general,
> install **one of them**. If you want both at the same time, see
> [this section](#installing-v1-and-v2-side-by-side).

---

## Installation

All `.deb` files are hosted in the **Push260922** release.

> <https://github.com/Hope2333/opencode-termux/releases/tag/Push260922>

### Option A — OpenCode v1 (1.18.32)

> **Note:** the v1 package installs a binary named `opencode1`. A symlink is
> created so it can be invoked with the `opencode` command.

```sh
# 1. Download
cd ~
curl -fL --retry 3 -o opencode1_1.18.32_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push260922/opencode1_1.18.32_aarch64.deb"

# 2. Inspect the package (optional)
dpkg-deb -I opencode1_1.18.32_aarch64.deb    # package metadata
dpkg-deb -c opencode1_1.18.32_aarch64.deb    # list files inside the package

# 3. Install
dpkg -i opencode1_1.18.32_aarch64.deb

# 4. Make it invocable as `opencode`
ln -sf "$PREFIX/bin/opencode1" "$PREFIX/bin/opencode"

# 5. Verify
opencode --version    # -> 1.18.32

# 6. Clean up the installer file
rm -f opencode1_1.18.32_aarch64.deb
```

### Option B — OpenCode v2 (2.0.12)

> **Note:** the v2 package ships a binary that is already named `opencode`,
> no extra steps needed.

```sh
# 1. Download
cd ~
curl -fL --retry 3 -o opencode_2.0.12_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push260922/opencode_2.0.12_aarch64.deb"

# 2. Inspect the package (optional)
dpkg-deb -I opencode_2.0.12_aarch64.deb    # package metadata
dpkg-deb -c opencode_2.0.12_aarch64.deb    # list files inside the package

# 3. Install
dpkg -i opencode_2.0.12_aarch64.deb

# 4. Verify
opencode --version    # -> opencode v2.0.12

# 5. Clean up the installer file
rm -f opencode_2.0.12_aarch64.deb
```

> v2 versions range from `2.0.0` to `2.0.12`. For another version, replace
> `2.0.12` in the file name in every command and in the URL, e.g.
> `opencode_2.0.10_aarch64.deb`.

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
> To pin a specific version, use manual installation (`dpkg -i`).

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

If you created the symlink for v1, remove it too:

```sh
rm -f "$PREFIX/bin/opencode"
```

---

## Troubleshooting

### Android 14 and below: "Bad system call" (SIGSYS)

On Android ≤ 14, the system seccomp policy can block the `close_range`
syscall (nr 436), so OpenCode dies at startup with *"Bad system call"*.
Use the official shim:

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
dpkg -i --force-conflicts opencode1_1.18.32_aarch64.deb
```

### Installing v1 and v2 side by side

Both versions can be installed together, but they use the same command name
(`opencode`), so one of them has to use a different name:

| Command | Version | How |
|---------|---------|-----|
| `opencode` | v2 | Binary shipped by the package |
| `opencode1` | v1 | Without the `opencode` symlink |

```sh
dpkg -i opencode_2.0.12_aarch64.deb      # v2  -> command `opencode`
dpkg -i --force-conflicts opencode1_1.18.32_aarch64.deb   # v1 -> command `opencode1`
```

---

## Technical Notes

### Package Families

The upstream repository provides several package variants:

| Family | Package | Description |
|--------|---------|-------------|
| native (mainline) | `opencode` / `opencode1` | Zero-glibc bionic ELF, directly executable |
| wrapper | `opencode-wrapper` / `opencode1-wrapper` | glibc wrapper (needs `glibc` + `openssl-glibc`) |
| compressed (UPX) | `opencode-compressed` / `opencode1-compressed` | UPX `--best`, smaller, slower startup |
| standalone | `opencode-wrapper-standalone` | Frozen version for rollback |

> This guide focuses on the **native** family (recommended).

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