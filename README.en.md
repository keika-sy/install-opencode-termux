<p align="center">
  🌐 <a href="./README.en.md">English</a> | <a href="./README.md">Bahasa Indonesia</a>
</p>

<div align="center">

# OpenCode for Termux

**Install OpenCode on Termux, minus the headache**

[![GitHub repo size](https://img.shields.io/github/repo-size/keika-sy/install-opencode-termux?style=for-the-badge&color=4B8BBE&label=Repo%20Size)](https://github.com/keika-sy/install-opencode-termux)
[![Platform](https://img.shields.io/badge/Platform-Termux-000000?style=for-the-badge&logo=android&logoColor=white)](https://termux.dev)
[![Architecture](https://img.shields.io/badge/Arch-aarch64-E95420?style=for-the-badge&logo=arm&logoColor=white)](#prerequisites)
[![License](https://img.shields.io/badge/License-MIT-3D9970?style=for-the-badge&logo=open-source-initiative&logoColor=white)](LICENSE)

<br/>

> This is a **native bionic build** — one pure ELF file. No glibc, no proot,
> no container. That's why it's light and just runs.

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

The short version: this repo shows you how to install **OpenCode** (the AI
coding agent that lives in your terminal) on **Termux**, and it comes with
an installer script that does the boring parts for you.

OpenCode doesn't ship a Termux build itself. Luckily,
[`Hope2333/opencode-termux`](https://github.com/Hope2333/opencode-termux)
builds a special "native bionic" variant, and this guide is built on top
of that work. What makes this build nice:

| Feature | Description |
|---------|-------------|
| **Zero glibc** | A single Bionic ELF file, no glibc dependency |
| **Built-in TUI** | Full terminal interface via `libopentui.so` |
| **No proot** | No container or chroot needed at all |
| **Fast** | Runs directly, no wrapper overhead |
| **Easy to install** | Just `dpkg -i` one file, or use the installer script |

---

## Prerequisites

Make sure your device ticks these boxes first:

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

If `uname -m` prints anything else, stop here — the packages simply only
exist for `aarch64`.

---

## Choosing a Version

There are **two generations** of OpenCode you can install. The gist:

| Version | Command | Latest Version | `.deb` File |
|:-------:|:-------:|:--------------:|:------------|
| **v1**  | `opencode1` | `1.19.3`      | `opencode1_1.19.3_aarch64.deb` |
| **v2**  | `opencode`  | `2.1.4`      | `opencode_2.1.4_aarch64.deb` |

| | v1 (1.18.x – 1.19.x) | v2 (2.0.x – 2.1.x) |
|---|---|---|
| **Status** | Maintenance line | Current mainline |
| **Package prefix** | `opencode1` | `opencode` |
| **Good for** | Compatibility | Most people |

So what's the actual difference? v2 is OpenCode's current release series —
new features and fixes land there first, so for everyday use **just pick
v2**. v1 is the older 1.x series, still maintained upstream for people who
need compatibility (say, an older setup that hasn't moved on yet). So far
upstream's v1 builds stop at **1.19.3**; anything newer than that only
exists as v2. The two generations also keep their data and configuration
completely separate, so switching generations never wipes the other one's
settings.

> **One thing worth knowing:** v1 and v2 both want the `opencode` command
> name. Normally you install **one of them**. If you really want both side
> by side, see [this section](#installing-v1-and-v2-side-by-side).

> ⚠️ **On Android 15/16? Read this first:** **2.1.4** currently has a bug
> that crashes its TUI on launch under Android 15/16. If that's your
> device, install **2.0.32** instead for now (tested working on
> Android 16; **2.0.24** is also fine). Details in
> [Troubleshooting](#v2-214-crashes-on-android-1516-pointer-exceeds-safe-integer-range).

---

## Installation

The latest `.deb` files live in per-generation releases: **v2 in
Push261026**, **v1 in Push261016**. Yes, different tags — the newest
version of each generation doesn't always show up in the same release.

> v2: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261026>
> v1: <https://github.com/Hope2333/opencode-termux/releases/tag/Push261016>

### Installer Script (Automatic)

The fastest route is the [`install.sh`](./install.sh) script from this
repo. You run it, it does the thinking: it asks the GitHub API what the
latest version of each generation is (auto mode — right now v2: **2.1.4**
in Push261026, v1: **1.19.3** in Push261016; the versions pinned inside
the script are just a fallback for when the API can't be reached),
downloads the file, matches its **SHA256** against the official
`SHA256SUMS.txt`, installs it with `dpkg -i`, and finally proves the
result actually runs.

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

(Yes, the menu itself is in Indonesian.) Type the number, hit Enter. When
an action finishes you're back at the menu — so checking for updates,
installing them, and uninstalling can all happen in one session without
re-running the script. The menu reads input straight from the terminal,
which is why it works even through the `curl | bash` one-liner above.

Don't want the menu? Easy: pass any argument (like `--v2`) and the script
goes straight to work without asking anything. Or set
`OPENCODE_NO_MENU=1`. And with no terminal attached (pipe/CI), it quietly
installs v2 directly, exactly like before.

#### How the script works

1. **Environment check** — makes sure the device is `aarch64`, `dpkg` is
   there, and `curl` is installed (it installs curl for you if not).
2. **Version resolution** — asks the GitHub API for the highest version of
   each generation and which release tag it lives in. If the API is
   unreachable, it falls back to its pinned versions and tells you.
3. **Download** — the `.deb` comes down with a **progress bar that adapts
   to your Termux screen width** (spinner, percent, size, and an estimated
   time left). Downloads have firm timeouts and retry automatically, so
   nothing hangs silently.
4. **SHA256 verification** — the file's checksum is matched against the
   official `SHA256SUMS.txt` from the same release. Mismatch = install
   cancelled.
5. **Install & verify** — `dpkg -i`, then the script runs
   `opencode --version` to prove the result really works.

No hidden steps: everything it does shows up as `[INFO]` / `[ OK ]` /
`[WARN]` lines in your terminal.

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

(The script's messages are in Indonesian.) Reading it is easy: a line
like `installed -> latest` means an update exists for that generation;
`sudah versi terbaru` means it's already up to date.

> About the update check: the script scans the upstream releases list via
> the GitHub API (including *prereleases*, since upstream's newest batches
> are prereleases) and picks the highest version per generation together
> with its release tag. That's how it doesn't fall behind.

### Option A — OpenCode v1 (1.19.3)

> The v1 package installs a binary called `opencode1`. To also call it
> with the plain `opencode` command, a symlink is created (step 5 below).
> The installer script does this automatically.

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

> ⚠️ **On Android 15/16? Don't install this one yet.** 2.1.4 currently
> has a TUI crash bug on Android 15/16. On those devices, follow the
> exact same steps but with the `opencode_2.0.32_aarch64.deb` file
> (same release, Push261026 — just swap the filename in every step).
> Bug details are in
> [Troubleshooting](#v2-214-crashes-on-android-1516-pointer-exceeds-safe-integer-range).
> On Android ≤ 14 this version is perfectly fine.

> The v2 package ships a binary that's already named `opencode`, so
> there are no extra steps at all.

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
> script with `--version` + `--tag`. That's also how you *downgrade* —
> for example dropping to `2.0.32` because of the 2.1.4 bug on
> Android 15/16.

### Option C — Software Source (apt / pacman)

Besides manual install, there's an official package source for
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

Each generation keeps its data and configuration in its own place, so
they never step on each other. It's also why updates, downgrades, and
even uninstalls never touch your settings — only the program package
itself gets replaced.

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

> **Note:** uninstalling only removes the package. Your data and
> configuration (`~/.config/opencode*`, `~/.local/share/opencode*`)
> stay put — history and settings are safe if you ever install again.
> Delete those folders by hand if you want a completely clean removal.

---

## Troubleshooting

### v2 2.1.4 crashes on Android 15/16: `Pointer exceeds safe integer range`

If `opencode` dies the moment you open it, with an error like this:

```text
Starting background server...
Error: Pointer exceeds safe integer range
    at createContext (...)
    at Tui.run (...)
```

...that's a **real upstream bug**, not your phone's fault and not a bad
install (`opencode --version` still works fine — only the TUI dies).
It's already reported in
[issue #43](https://github.com/Hope2333/opencode-termux/issues/43) and
[issue #45](https://github.com/Hope2333/opencode-termux/issues/45).

The short version of the root cause: on Android 15/16, the system
allocator tags the top byte of heap pointers, which makes pointer
values bigger than JavaScript's maximum safe integer. OpenTUI's FFI
layer (the TUI library OpenCode uses) isn't ready for pointers that
big and gives up. Android ≤ 14 doesn't have this problem.

**Workaround for now: drop back to 2.0.32** — it ships in the same
release as 2.1.4, but it's a different build and is tested working on
Android 16:

```sh
bash install.sh --version 2.0.32 --tag Push261026
```

Version **2.0.24** is also confirmed fine (from the issue reports), so
it's a valid alternative. The point: so far the only build confirmed
to have this bug is **2.1.4** itself. A `.deb` can simply be
overwritten with another version (downgrading is a normal dpkg thing,
and your data isn't touched). Once upstream ships a fix, just
`bash install.sh --update` to climb back to the latest.

One note: non-TUI modes like `opencode serve` and `opencode run "..."`
probably still work on 2.1.4 since the crash lives in the TUI path,
but that hasn't been officially verified.

### Older Android: "Bad system call" (SIGSYS)

On older Android (reported case: Android 12, generally ≤ 14), the system
seccomp policy can block the `close_range` syscall (nr 436), so OpenCode
dies at startup with *"Bad system call"*.

**The good news:** recent native packages ship the
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

Some v2 builds carry `Conflicts: opencode1` metadata. If `dpkg -i` fails
with that message (usually when installing v1), add `--force-conflicts`:

```sh
dpkg -i --force-conflicts opencode1_1.19.3_aarch64.deb
```

### Downloads fail, stall, or the script seems to hang

The usual suspect is a connection dropping mid-download — the `.deb` is
big (v2 is about 76 MB) and the GitHub API releases list is about
1–2 MB. The installer script already expects this: firm per-attempt
timeouts, automatic retries (up to 3), and a progress bar that shows
whether the download is actually moving or stuck. If it still fails:

1. Check your internet connection, then just run the same script again.
   Re-running is safe and won't break an existing install.
2. When installing manually, add `--retry 3` to your `curl` commands.
3. If the GitHub API throws a transient error (rate limit on a shared IP
   address), wait a few minutes and try again.

### Checksum mismatch

This means the file you downloaded is **not identical** to the official
one in the release — most often because the download got interrupted or
corrupted. The script cancels the installation for safety, which is the
right call. Run it again to grab a fresh copy. Don't reach for
`--no-verify` unless you understand the risk and have checked the file
yourself.

### `opencode: command not found` after installing

The package is installed, but your shell hasn't picked up the new
command yet. Close and reopen Termux, or run `hash -r`, then try again.
If you installed **v1 only, manually**, remember its real command is
`opencode1` — the `opencode` command only exists if the symlink was
created (the installer script makes it automatically in `--v1` mode).

### Unsupported architecture / storage full

Upstream packages only exist for **aarch64** — 32-bit (`armv7l`) or
`x86_64` devices can't use this guide, full stop. For storage: the
download plus the installed package needs ~200 MB free. Free up space
(if needed, `apt clean` and delete old `.deb` files), then retry.

### Installing v1 and v2 side by side

Both can be installed together, but they share the same command name
(`opencode`), so one of them has to go by a different name:

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
Nope. Everything runs as a regular Termux user.

**Does updating erase my configuration and history?**
No. Updates (and downgrades, and uninstalls) only replace the program
package. Your configuration, data, and session history live in
`~/.config/opencode*` and `~/.local/share/opencode*`, separate from the
package — see [Uninstall](#uninstall) too.

**Which version should I install?**
v2, unless you have a specific reason to stay on 1.x. One exception,
for now: if you're on **Android 15/16**, grab **2.0.32** instead,
because 2.1.4 currently has a TUI crash bug there (details under
Troubleshooting).

**What's the difference between the script and manual install?**
The end result is exactly the same official `.deb`, installed with
`dpkg -i` either way. The script just does the boring steps for you:
picking the latest version per generation, downloading, verifying the
SHA256, installing, and proving it runs. The manual route gives you
full control over each step.

**Why does SHA256 verification matter?**
A checksum proves the file you downloaded is intact and identical to
what upstream published — not corrupted by an interrupted download, and
not tampered with by someone in between.

**Can I install a specific older version (e.g. to roll back)?**
Absolutely — a `.deb` can simply be overwritten with an older version;
downgrading is a normal thing. Use the script's `--version` + `--tag`
(example in the Installer Script section), or grab the `.deb` manually
from the matching release tag. Just remember the latest version of each
generation may live under a different tag.

**Do I need an internet connection?**
Yes — to download the package and to check for the latest version. Once
installed, OpenCode itself still needs internet to talk to whichever AI
model provider you use.

**How large is the download?**
The `.deb` packages are tens of MB (v2 2.1.4: about 76 MB), plus a small
checksum file. Keep ~200 MB free so `dpkg` extraction has room to work.

**Is this guide official from the OpenCode team?**
No — it's a community guide built on Hope2333's Termux build. See
[Credits](#credits).

---

## Technical Notes

### Package Families

The upstream repo provides several package variants:

| Family | Package | Description |
|--------|---------|-------------|
| native (mainline) | `opencode` / `opencode1` | Zero-glibc bionic ELF, directly executable |
| wrapper | `opencode-wrapper` / `opencode1-wrapper` | glibc wrapper (needs `glibc` + `openssl-glibc`) |
| compressed (UPX) | `opencode-compressed` / `opencode1-compressed` | UPX, smaller, slower startup |
| standalone | `opencode-wrapper-standalone` | Frozen version for rollback |

> This guide focuses on the **native** family (the recommended one).
> Within one generation, the native / wrapper / compressed families are
> **mutually exclusive** — install exactly one. Across generations
> (`opencode1*` with `opencode*`) they can coexist just fine.

### Package Naming History

- `opencode-glibc` → `opencode-wrapper` (renamed, with an automatic upgrade
  path via `Replaces`/`Breaks`).
- v1 packages now use the `opencode1*` prefix so they can sit next to the
  v2 `opencode` package on the same device.

---

## Credits

- **OpenCode** — [anomalyco/opencode](https://github.com/anomalyco/opencode)
- **Termux build** — [Hope2333/opencode-termux](https://github.com/Hope2333/opencode-termux)
- **Installation wiki** — [hope2333.github.io](https://hope2333.github.io/wiki/opencode-termux/)

> **Disclaimer:** This repo is a **community installation guide** for
> running OpenCode on Termux. It is **not** made by the OpenCode team, is
> **not affiliated** with them, and is **not endorsed** by them.

<div align="center">

---

Made with ❤️ by [@keika-sy](https://github.com/keika-sy)

</div>
