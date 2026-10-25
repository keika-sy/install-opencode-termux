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
  - [Option B — OpenCode v2 (2.0.31)](#option-b--opencode-v2-2031)
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
| **v2**  | `opencode`  | `2.0.31`      | `opencode_2.0.31_aarch64.deb` |

| | v1 (1.18.x – 1.19.x) | v2 (2.0.x) |
|---|---|---|
| **Status** | Maintenance line | Current mainline |
| **Package prefix** | `opencode1` | `opencode` |
| **Recommended** | For compatibility | For general use |

> **Note:** v1 and v2 both want to use the `opencode` command. In general,
> install **one of them**. If you want both at the same time, see
> [this section](#installing-v1-and-v2-side-by-side).

---

## Installation

All `.deb` files for the latest versions are hosted in the **Push261016** release.

> <https://github.com/Hope2333/opencode-termux/releases/tag/Push261016>

### Installer Script (Automatic)

The fastest way: use the [`install.sh`](./install.sh) script from this
repository. It downloads the package from the **Push261016** release,
verifies its **SHA256** against the official `SHA256SUMS.txt`, installs it
with `dpkg -i`, and verifies the result.

**One-liner** (installs v2 — the default):

```sh
curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash
```

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
| `--v2` | Install OpenCode v2 (default) |
| `--v1` | Install OpenCode v1 only (+ `opencode` symlink) |
| `--both` | Install v1 + v2 side by side |
| `--version <ver>` | Install a specific version (adjust `--tag` too) |
| `--tag <tag>` | Upstream release tag (default: `Push261016`) |
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

### Option B — OpenCode v2 (2.0.31)

> **Note:** the v2 package ships a binary that is already named `opencode`,
> no extra steps needed.

```sh
# 1. Download
cd ~
curl -fL --retry 3 -o opencode_2.0.31_aarch64.deb \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261016/opencode_2.0.31_aarch64.deb"

# 2. Verify the checksum (recommended)
curl -fsSL -o SHA256SUMS.txt \
  "https://github.com/Hope2333/opencode-termux/releases/download/Push261016/SHA256SUMS.txt"
grep "opencode_2.0.31_aarch64.deb" SHA256SUMS.txt | sha256sum -c -

# 3. Inspect the package (optional)
dpkg-deb -I opencode_2.0.31_aarch64.deb    # package metadata
dpkg-deb -c opencode_2.0.31_aarch64.deb    # list files inside the package

# 4. Install
dpkg -i opencode_2.0.31_aarch64.deb

# 5. Verify
opencode --version    # -> opencode v2.0.31

# 6. Clean up the installer files
rm -f opencode_2.0.31_aarch64.deb SHA256SUMS.txt
```

> v2 versions range from `2.0.0` to `2.0.31`, and v1 from `1.18.8` to
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

### Installing v1 and v2 side by side

Both versions can be installed together, but they use the same command name
(`opencode`), so one of them has to use a different name:

| Command | Version | How |
|---------|---------|-----|
| `opencode` | v2 | Binary shipped by the package |
| `opencode1` | v1 | Without the `opencode` symlink |

```sh
dpkg -i opencode_2.0.31_aarch64.deb      # v2  -> command `opencode`
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb   # v1 -> command `opencode1`
```

Or simply run the installer script with `bash install.sh --both`.

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
