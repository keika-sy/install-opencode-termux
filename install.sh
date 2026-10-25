#!/usr/bin/env bash
# ============================================================================
# install.sh — Installer OpenCode for Termux (native bionic build)
#
# Repo panduan : https://github.com/keika-sy/install-opencode-termux
# Build upstream: https://github.com/Hope2333/opencode-termux
#
# Versi bawaan (release Push261016, batch terbaru saat script ini ditulis):
#   - OpenCode v2 : 2.0.31   (paket: opencode)
#   - OpenCode v1 : 1.19.3   (paket: opencode1)
#
# Contoh pemakaian:
#   bash install.sh                 # pasang v2 (bawaan)
#   bash install.sh --v1            # pasang v1 saja
#   bash install.sh --both          # pasang v1 + v2 berdampingan
#   bash install.sh --version 2.0.27 --tag Push261013
#   bash install.sh --uninstall v2  # copot pemasangan
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --v1
# ============================================================================

set -euo pipefail

# --- Konfigurasi bawaan ------------------------------------------------------
RELEASE_TAG="${OPENCODE_TAG:-Push261016}"
V2_VERSION="2.0.31"
V1_VERSION="1.19.3"
UPSTREAM="Hope2333/opencode-termux"

# --- Opsi (diisi dari argumen) ------------------------------------------------
TARGET="v2"            # v2 | v1 | both
CUSTOM_VERSION=""
UNINSTALL=""
NO_VERIFY=0
FORCE_CONFLICTS=0
KEEP_FILE=0

# --- Utilitas tampilan ---------------------------------------------------------
if [ -t 1 ]; then
  C_RESET='\033[0m'; C_BOLD='\033[1m'; C_GREEN='\033[32m'; C_RED='\033[31m'; C_YELLOW='\033[33m'; C_CYAN='\033[36m'
else
  C_RESET=''; C_BOLD=''; C_GREEN=''; C_RED=''; C_YELLOW=''; C_CYAN=''
fi
info()  { printf "${C_CYAN}[INFO]${C_RESET} %s\n" "$*"; }
ok()    { printf "${C_GREEN}[ OK ]${C_RESET} %s\n" "$*"; }
warn()  { printf "${C_YELLOW}[WARN]${C_RESET} %s\n" "$*"; }
die()   { printf "${C_RED}[ERROR]${C_RESET} %s\n" "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
Installer OpenCode for Termux (native bionic build)

Pemakaian: bash install.sh [opsi]

Opsi:
  --v2                  Pasang OpenCode v2 (bawaan)
  --v1                  Pasang OpenCode v1 saja
  --both                Pasang v1 + v2 berdampingan
  --version <versi>     Pasang versi tertentu (tentukan juga --tag bila
                        versi itu bukan versi bawaan script ini)
  --tag <tag>           Tag release upstream (bawaan: Push261016)
  --no-verify           Lewati verifikasi SHA256
  --force-conflicts     Teruskan --force-conflicts ke dpkg
  --keep                Simpan file .deb hasil unduhan (di folder saat ini)
  --uninstall <target>  Copot paket: v1 | v2 | all
  -h, --help            Tampilkan bantuan ini

Contoh:
  bash install.sh
  bash install.sh --v1
  bash install.sh --both
  bash install.sh --version 2.0.27 --tag Push261013
  bash install.sh --uninstall all
EOF
}

# --- Baca argumen ---------------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --v2)   TARGET="v2" ;;
    --v1)   TARGET="v1" ;;
    --both) TARGET="both" ;;
    --version)
      [ $# -ge 2 ] || die "--version butuh nilai, contoh: --version 2.0.31"
      CUSTOM_VERSION="$2"; shift ;;
    --tag)
      [ $# -ge 2 ] || die "--tag butuh nilai, contoh: --tag Push261016"
      RELEASE_TAG="$2"; shift ;;
    --no-verify)       NO_VERIFY=1 ;;
    --force-conflicts) FORCE_CONFLICTS=1 ;;
    --keep)            KEEP_FILE=1 ;;
    --uninstall)
      [ $# -ge 2 ] || die "--uninstall butuh nilai: v1 | v2 | all"
      UNINSTALL="$2"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) die "Opsi tidak dikenal: $1 (lihat --help)" ;;
  esac
  shift
done

# --- Pemeriksaan lingkungan -------------------------------------------------------
check_env() {
  # Termux?
  if [ -z "${PREFIX:-}" ] && [ -z "${TERMUX_VERSION:-}" ]; then
    warn "Variabel PREFIX/TERMUX_VERSION tidak ditemukan — script ini dibuat untuk Termux."
  fi
  PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"

  # Arsitektur
  local arch
  arch="$(uname -m)"
  [ "$arch" = "aarch64" ] || die "Arsitektur tidak didukung: $arch (paket ini hanya untuk aarch64)."

  # dpkg wajib ada
  command -v dpkg >/dev/null 2>&1 || die "dpkg tidak ditemukan. Script ini hanya untuk Termux berbasis apt/dpkg."

  # curl: pasang otomatis bila belum ada dan pkg tersedia
  if ! command -v curl >/dev/null 2>&1; then
    if command -v pkg >/dev/null 2>&1; then
      info "curl belum terpasang, memasang curl..."
      pkg install -y curl
    else
      die "curl tidak ditemukan dan pkg tidak tersedia untuk memasangnya."
    fi
  fi

  # sha256sum (bagian dari coreutils, normalnya selalu ada di Termux)
  if [ "$NO_VERIFY" -eq 0 ] && ! command -v sha256sum >/dev/null 2>&1; then
    warn "sha256sum tidak ditemukan — verifikasi checksum dilewati."
    NO_VERIFY=1
  fi
}

# --- Uninstall ---------------------------------------------------------------------
do_uninstall() {
  case "$UNINSTALL" in
    v1|v2|all) ;;
    *) die "--uninstall harus salah satu dari: v1 | v2 | all" ;;
  esac
  if [ "$UNINSTALL" = "v1" ] || [ "$UNINSTALL" = "all" ]; then
    info "Mencopot paket opencode1 (v1)..."
    dpkg -r opencode1 || warn "Paket opencode1 tidak terpasang / gagal dicopot."
    # Hapus symlink 'opencode' HANYA bila ia menunjuk ke opencode1
    if [ -L "$PREFIX/bin/opencode" ] && [ "$(readlink "$PREFIX/bin/opencode" 2>/dev/null || true)" = "$PREFIX/bin/opencode1" ]; then
      rm -f "$PREFIX/bin/opencode"
      info "Symlink opencode -> opencode1 dihapus."
    fi
  fi
  if [ "$UNINSTALL" = "v2" ] || [ "$UNINSTALL" = "all" ]; then
    info "Mencopot paket opencode (v2)..."
    dpkg -r opencode || warn "Paket opencode tidak terpasang / gagal dicopot."
  fi
  ok "Uninstall selesai."
  exit 0
}

# --- Pasang satu generasi ------------------------------------------------------------
# $1 = generasi (v1|v2)   $2 = versi   $3 = "symlink" bila v1 perlu alias opencode
install_one() {
  local gen="$1" version="$2" make_symlink="${3:-}"
  local pkg file url sums_url workdir
  if [ "$gen" = "v2" ]; then pkg="opencode"; else pkg="opencode1"; fi
  file="${pkg}_${version}_aarch64.deb"
  url="https://github.com/${UPSTREAM}/releases/download/${RELEASE_TAG}/${file}"
  sums_url="https://github.com/${UPSTREAM}/releases/download/${RELEASE_TAG}/SHA256SUMS.txt"

  workdir="$(mktemp -d "${TMPDIR:-/tmp}/opencode-install.XXXXXX")"
  # shellcheck disable=SC2064  # $workdir memang harus diekspansi sekarang
  trap "rm -rf '$workdir'" EXIT

  info "Mengunduh ${file} (release ${RELEASE_TAG})..."
  curl -fL --retry 3 --progress-bar -o "$workdir/$file" "$url" \
    || die "Unduhan gagal: $url"

  if [ "$NO_VERIFY" -eq 0 ]; then
    info "Memverifikasi SHA256..."
    curl -fsSL --retry 3 -o "$workdir/SHA256SUMS.txt" "$sums_url" \
      || die "Gagal mengunduh SHA256SUMS.txt dari release ${RELEASE_TAG}."
    if grep -F "  $file" "$workdir/SHA256SUMS.txt" > "$workdir/check.txt" 2>/dev/null \
       || grep -F " $file" "$workdir/SHA256SUMS.txt" > "$workdir/check.txt" 2>/dev/null; then
      ( cd "$workdir" && sha256sum -c check.txt ) \
        || die "Checksum TIDAK cocok untuk $file — pemasangan dibatalkan."
      ok "Checksum cocok."
    else
      die "$file tidak ditemukan di SHA256SUMS.txt release ${RELEASE_TAG} — pemasangan dibatalkan (atau pakai --no-verify)."
    fi
  else
    warn "Verifikasi SHA256 dilewati (--no-verify)."
  fi

  info "Memasang paket ${pkg} ${version}..."
  if [ "$FORCE_CONFLICTS" -eq 1 ]; then
    dpkg -i --force-conflicts "$workdir/$file"
  else
    dpkg -i "$workdir/$file" \
      || die "dpkg gagal. Bila muncul konflik antar-generasi (\"conflicts with\"), coba lagi dengan --force-conflicts."
  fi

  if [ "$KEEP_FILE" -eq 1 ]; then
    cp -f "$workdir/$file" "./$file"
    info "File installer disimpan di: $(pwd)/$file"
  fi

  rm -rf "$workdir"
  trap - EXIT

  if [ "$gen" = "v1" ] && [ "$make_symlink" = "symlink" ]; then
    ln -sf "$PREFIX/bin/opencode1" "$PREFIX/bin/opencode"
    info "Symlink dibuat: opencode -> opencode1"
  fi

  ok "${pkg} ${version} terpasang."
}

# --- Main --------------------------------------------------------------------------------
printf "${C_BOLD}OpenCode for Termux — Installer${C_RESET}\n"
printf "Upstream: %s | Release: %s\n\n" "$UPSTREAM" "$RELEASE_TAG"

check_env

if [ -n "$UNINSTALL" ]; then
  do_uninstall
fi

# Tentukan versi final per generasi
v2_ver="$V2_VERSION"
v1_ver="$V1_VERSION"
if [ -n "$CUSTOM_VERSION" ]; then
  case "$CUSTOM_VERSION" in
    1.*) v1_ver="$CUSTOM_VERSION"; [ "$TARGET" = "both" ] || TARGET="v1" ;;
    2.*) v2_ver="$CUSTOM_VERSION"; [ "$TARGET" = "both" ] || TARGET="v2" ;;
    *)   die "Format versi tidak dikenal: $CUSTOM_VERSION (harus diawali 1. atau 2.)" ;;
  esac
  info "Versi kustom diminta: $CUSTOM_VERSION (tag: $RELEASE_TAG)"
fi

case "$TARGET" in
  v2)   install_one "v2" "$v2_ver" ;;
  v1)   install_one "v1" "$v1_ver" "symlink" ;;
  both)
    install_one "v2" "$v2_ver"
    # v1 berdampingan: JANGAN buat symlink — perintah 'opencode' milik v2,
    # v1 dipanggil dengan 'opencode1'.
    if [ "$FORCE_CONFLICTS" -eq 0 ]; then
      warn "Mode berdampingan: memasang v1 dengan --force-conflicts (metadata sebagian build v2 menyatakan konflik dengan opencode1)."
      FORCE_CONFLICTS=1
    fi
    install_one "v1" "$v1_ver"
    ;;
esac

echo
info "Verifikasi hasil pemasangan:"
if [ "$TARGET" = "v2" ] || [ "$TARGET" = "both" ]; then
  printf "  opencode  -> "; opencode --version 2>/dev/null || echo "(gagal dijalankan)"
fi
if [ "$TARGET" = "v1" ] || [ "$TARGET" = "both" ]; then
  printf "  opencode1 -> "; opencode1 --version 2>/dev/null || echo "(gagal dijalankan)"
fi
echo
ok "Selesai! Jalankan 'opencode' untuk membuka TUI."
