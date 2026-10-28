#!/usr/bin/env bash
# ============================================================================
# install.sh — Installer OpenCode for Termux (native bionic build)
#
# Repo panduan : https://github.com/keika-sy/install-opencode-termux
# Build upstream: https://github.com/Hope2333/opencode-termux
#
# Versi bawaan (batch terbaru tiap generasi saat script ini ditulis):
#   - OpenCode v2 : 2.1.4    (paket: opencode,  release Push261026)
#   - OpenCode v1 : 1.19.3   (paket: opencode1, release Push261016)
# Per generasi tag-nya bisa berbeda — versi terbaru tiap generasi tidak
# selalu berada di release yang sama.
#
# Contoh pemakaian:
#   bash install.sh                 # pasang v2 (bawaan)
#   bash install.sh --v1            # pasang v1 saja
#   bash install.sh --both          # pasang v1 + v2 berdampingan
#   bash install.sh --version 2.0.27 --tag Push261013
#   bash install.sh --check-update  # cek versi terbaru di upstream
#   bash install.sh --update        # perbarui paket terpasang ke versi terbaru
#   bash install.sh --uninstall v2  # copot pemasangan
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/keika-sy/install-opencode-termux/main/install.sh | bash -s -- --v1
# ============================================================================

set -euo pipefail

# --- Konfigurasi bawaan ------------------------------------------------------
V2_VERSION="2.1.4"
V1_VERSION="1.19.3"
V2_TAG="Push261026"
V1_TAG="Push261016"
UPSTREAM="Hope2333/opencode-termux"
# --tag / $OPENCODE_TAG menimpa tag untuk SEMUA generasi sekaligus.
TAG_OVERRIDE=0
RELEASE_TAG=""
if [ -n "${OPENCODE_TAG:-}" ]; then
  RELEASE_TAG="$OPENCODE_TAG"; TAG_OVERRIDE=1
fi

# Tag efektif untuk satu generasi (memperhitungkan --tag override)
gen_tag() {
  if [ "$TAG_OVERRIDE" -eq 1 ]; then
    printf '%s' "$RELEASE_TAG"
  elif [ "$1" = "v2" ]; then
    printf '%s' "$V2_TAG"
  else
    printf '%s' "$V1_TAG"
  fi
}

# --- Opsi (diisi dari argumen) ------------------------------------------------
TARGET="v2"            # v2 | v1 | both
CUSTOM_VERSION=""
UNINSTALL=""
MODE=""                # check | update
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
  --tag <tag>           Paksa satu tag release upstream untuk semua
                        generasi (bawaan: per generasi — v2 Push261026,
                        v1 Push261016)
  --no-verify           Lewati verifikasi SHA256
  --force-conflicts     Teruskan --force-conflicts ke dpkg
  --keep                Simpan file .deb hasil unduhan (di folder saat ini)
  --check-update        Cek versi terbaru di upstream dan bandingkan
                        dengan versi yang terpasang
  --update              Perbarui paket yang terpasang ke versi terbaru
  --uninstall <target>  Copot paket: v1 | v2 | all
  -h, --help            Tampilkan bantuan ini

Contoh:
  bash install.sh
  bash install.sh --v1
  bash install.sh --both
  bash install.sh --version 2.0.27 --tag Push261013
  bash install.sh --check-update
  bash install.sh --update
  bash install.sh --uninstall all

Catatan:
  Tanpa --version, versi yang dipasang SELALU versi terbaru dari GitHub
  API (mode auto); pin versi di script hanya cadangan bila API tidak
  terjangkau. Opsi --tag menonaktifkan mode auto (memaksa satu tag
  release dengan versi pin).
EOF
}

# --- Baca argumen ---------------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --v2)   TARGET="v2" ;;
    --v1)   TARGET="v1" ;;
    --both) TARGET="both" ;;
    --version)
      [ $# -ge 2 ] || die "--version butuh nilai, contoh: --version 2.1.4"
      CUSTOM_VERSION="$2"; shift ;;
    --tag)
      [ $# -ge 2 ] || die "--tag butuh nilai, contoh: --tag Push261016"
      RELEASE_TAG="$2"; TAG_OVERRIDE=1; shift ;;
    --no-verify)       NO_VERIFY=1 ;;
    --force-conflicts) FORCE_CONFLICTS=1 ;;
    --keep)            KEEP_FILE=1 ;;
    --check-update)    MODE="check" ;;
    --update)          MODE="update" ;;
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

# --- Cek update ----------------------------------------------------------------------
API_URL="https://api.github.com/repos/${UPSTREAM}/releases?per_page=10"
LATEST_V2_VER=""; LATEST_V2_TAG=""
LATEST_V1_VER=""; LATEST_V1_TAG=""

# is_newer A B -> sukses (0) bila A lebih baru dari B
is_newer() {
  [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | tail -n 1)" = "$1" ]
}

# Ambil versi terbaru per generasi dari daftar releases di GitHub API.
# SENGAJA tidak memakai endpoint /releases/latest: upstream menandainya ke
# batch lama karena batch-batch baru berstatus prerelease, jadi daftar
# releases (termasuk prerelease) dipindai dan versi tertinggi per generasi
# diambil beserta tag release tempat file itu berada.
fetch_latest() {
  local tmpjson line tag ver attempt fetched=0
  tmpjson="$(mktemp "${TMPDIR:-/tmp}/opencode-releases.XXXXXX")" || return 1
  info "Menghubungi GitHub API untuk daftar releases ${UPSTREAM}..."
  # Unduh ke file dengan progress bar + timeout tegas: payload JSON ini
  # besar (±1-2MB) — mengunduhnya diam-diam ke variabel tanpa timeout
  # membuat script terlihat hang selamanya bila koneksi stall.
  # GitHub juga kadang membalas 403 sesaat (rate limit IP bersama/NAT),
  # jadi dicoba sampai 3x sebelum menyerah.
  for attempt in 1 2 3; do
    if [ "$attempt" -gt 1 ]; then
      info "Percobaan ${attempt}/3..."
      sleep 3
    fi
    if curl -fSL --connect-timeout 15 --max-time 90 --progress-bar \
         -H 'Accept: application/vnd.github+json' -o "$tmpjson" "$API_URL"; then
      fetched=1; break
    fi
  done
  if [ "$fetched" -ne 1 ] || [ ! -s "$tmpjson" ]; then
    rm -f "$tmpjson"; return 1
  fi
  tag=""
  while IFS= read -r line; do
    case "$line" in
      *'"tag_name": '*)
        tag="$(printf '%s' "$line" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')" ;;
      *opencode1_*_aarch64.deb*)
        ver="$(printf '%s' "$line" | sed -n 's/.*opencode1_\([0-9][0-9.]*\)_aarch64\.deb.*/\1/p')"
        if [ -n "$ver" ] && { [ -z "$LATEST_V1_VER" ] || is_newer "$ver" "$LATEST_V1_VER"; }; then
          LATEST_V1_VER="$ver"; LATEST_V1_TAG="$tag"
        fi ;;
      *opencode_*_aarch64.deb*)
        ver="$(printf '%s' "$line" | sed -n 's/.*opencode_\([0-9][0-9.]*\)_aarch64\.deb.*/\1/p')"
        if [ -n "$ver" ] && { [ -z "$LATEST_V2_VER" ] || is_newer "$ver" "$LATEST_V2_VER"; }; then
          LATEST_V2_VER="$ver"; LATEST_V2_TAG="$tag"
        fi ;;
    esac
  done < "$tmpjson"
  rm -f "$tmpjson"
  [ -n "$LATEST_V2_VER" ] || return 1
  [ -n "$LATEST_V1_VER" ] || return 1
}

# Versi paket yang terpasang untuk satu generasi (kosong bila tidak terpasang)
installed_version() {
  local gen="$1" pkg bin ver=""
  if [ "$gen" = "v2" ]; then pkg="opencode"; bin="opencode"; else pkg="opencode1"; bin="opencode1"; fi
  if command -v dpkg-query >/dev/null 2>&1; then
    ver="$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null || true)"
  fi
  if [ -z "$ver" ] && command -v "$bin" >/dev/null 2>&1; then
    ver="$("$bin" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || true)"
  fi
  printf '%s' "$ver"
}

# Laporan status satu generasi: 0 = ada update, 1 = tidak ada / belum terpasang
check_one() {
  local gen="$1" hver="$2" htag="$3" cur
  cur="$(installed_version "$gen")"
  if [ -z "$cur" ]; then
    printf '  %-4s : belum terpasang — versi terbaru %s (release %s)\n' "$gen" "$hver" "$htag"
    return 1
  fi
  if is_newer "$hver" "$cur"; then
    printf '  %-4s : %s -> %s (release %s) — UPDATE TERSEDIA\n' "$gen" "$cur" "$hver" "$htag"
    return 0
  fi
  printf '  %-4s : %s — sudah versi terbaru\n' "$gen" "$cur"
  return 1
}

do_check_update() {
  fetch_latest || die "Tidak bisa menghubungi GitHub API setelah 3 percobaan — cek koneksi internet kamu. Info offline dari pin script: v2 $V2_VERSION ($V2_TAG), v1 $V1_VERSION ($V1_TAG)."
  echo "Status versi:"
  check_one "v2" "$LATEST_V2_VER" "$LATEST_V2_TAG" || true
  check_one "v1" "$LATEST_V1_VER" "$LATEST_V1_TAG" || true
  echo
  info "Perbarui yang terpasang dengan: bash install.sh --update"
  exit 0
}

do_update() {
  fetch_latest || die "Tidak bisa menghubungi GitHub API setelah 3 percobaan — update dibatalkan, cek koneksi internet kamu."
  local updated=0 any=0 cur
  cur="$(installed_version "v2")"
  if [ -n "$cur" ]; then
    any=1
    if is_newer "$LATEST_V2_VER" "$cur"; then
      info "Memperbarui v2: $cur -> $LATEST_V2_VER (release $LATEST_V2_TAG)"
      install_one "v2" "$LATEST_V2_VER" "" "$LATEST_V2_TAG"
      updated=1
    else
      ok "v2 sudah versi terbaru ($cur)."
    fi
  fi
  cur="$(installed_version "v1")"
  if [ -n "$cur" ]; then
    any=1
    if is_newer "$LATEST_V1_VER" "$cur"; then
      info "Memperbarui v1: $cur -> $LATEST_V1_VER (release $LATEST_V1_TAG)"
      # Symlink 'opencode' hanya dipertahankan bila v2 tidak terpasang.
      if [ -z "$(installed_version "v2")" ]; then
        install_one "v1" "$LATEST_V1_VER" "symlink" "$LATEST_V1_TAG"
      else
        install_one "v1" "$LATEST_V1_VER" "" "$LATEST_V1_TAG"
      fi
      updated=1
    else
      ok "v1 sudah versi terbaru ($cur)."
    fi
  fi
  [ "$any" -eq 1 ] || die "Tidak ada paket opencode/opencode1 yang terpasang. Pasang dulu dengan: bash install.sh"
  if [ "$updated" -eq 1 ]; then
    ok "Update selesai."
  else
    ok "Semua paket sudah versi terbaru — tidak ada yang diperbarui."
  fi
  exit 0
}

# --- Pasang satu generasi ------------------------------------------------------------
# $1 = generasi (v1|v2)   $2 = versi   $3 = "symlink" bila v1 perlu alias opencode
# $4 = tag release (opsional; bawaan: tag efektif generasi itu)
install_one() {
  local gen="$1" version="$2" make_symlink="${3:-}" tag="${4:-}"
  local pkg file url sums_url workdir
  if [ "$gen" = "v2" ]; then pkg="opencode"; else pkg="opencode1"; fi
  [ -n "$tag" ] || tag="$(gen_tag "$gen")"
  file="${pkg}_${version}_aarch64.deb"
  url="https://github.com/${UPSTREAM}/releases/download/${tag}/${file}"
  sums_url="https://github.com/${UPSTREAM}/releases/download/${tag}/SHA256SUMS.txt"

  workdir="$(mktemp -d "${TMPDIR:-/tmp}/opencode-install.XXXXXX")"
  # shellcheck disable=SC2064  # $workdir memang harus diekspansi sekarang
  trap "rm -rf '$workdir'" EXIT

  info "Mengunduh ${file} (release ${tag})..."
  curl -fL --retry 3 --connect-timeout 20 --progress-bar -o "$workdir/$file" "$url" \
    || die "Unduhan gagal: $url"

  if [ "$NO_VERIFY" -eq 0 ]; then
    info "Memverifikasi SHA256..."
    curl -fsSL --retry 3 --connect-timeout 20 -o "$workdir/SHA256SUMS.txt" "$sums_url" \
      || die "Gagal mengunduh SHA256SUMS.txt dari release ${tag}."
    if grep -F "  $file" "$workdir/SHA256SUMS.txt" > "$workdir/check.txt" 2>/dev/null \
       || grep -F " $file" "$workdir/SHA256SUMS.txt" > "$workdir/check.txt" 2>/dev/null; then
      ( cd "$workdir" && sha256sum -c check.txt ) \
        || die "Checksum TIDAK cocok untuk $file — pemasangan dibatalkan."
      ok "Checksum cocok."
    else
      die "$file tidak ditemukan di SHA256SUMS.txt release ${tag} — pemasangan dibatalkan (atau pakai --no-verify)."
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
printf "Upstream: %s | v2 %s (%s) | v1 %s (%s)\n\n" \
  "$UPSTREAM" "$V2_VERSION" "$(gen_tag v2)" "$V1_VERSION" "$(gen_tag v1)"

check_env

if [ -n "$UNINSTALL" ]; then
  do_uninstall
fi

if [ "$MODE" = "check" ]; then
  do_check_update
fi

if [ "$MODE" = "update" ]; then
  do_update
fi

# Tentukan versi final per generasi
v2_ver="$V2_VERSION"; v2_tag=""
v1_ver="$V1_VERSION"; v1_tag=""
if [ -n "$CUSTOM_VERSION" ]; then
  case "$CUSTOM_VERSION" in
    1.*) v1_ver="$CUSTOM_VERSION"; [ "$TARGET" = "both" ] || TARGET="v1" ;;
    2.*) v2_ver="$CUSTOM_VERSION"; [ "$TARGET" = "both" ] || TARGET="v2" ;;
    *)   die "Format versi tidak dikenal: $CUSTOM_VERSION (harus diawali 1. atau 2.)" ;;
  esac
  info "Versi kustom diminta: $CUSTOM_VERSION (tag: $(gen_tag "$TARGET"))"
elif [ "$TAG_OVERRIDE" -eq 1 ]; then
  info "Tag dipaksa via --tag/$OPENCODE_TAG: memakai versi pin bawaan script."
else
  # Mode AUTO (bawaan): selalu ambil versi terbaru dari GitHub API.
  # Pin di script hanya jadi cadangan bila API tidak terjangkau.
  if fetch_latest; then
    v2_ver="$LATEST_V2_VER"; v2_tag="$LATEST_V2_TAG"
    v1_ver="$LATEST_V1_VER"; v1_tag="$LATEST_V1_TAG"
    info "Mode auto: versi terbaru upstream — v2 $v2_ver ($v2_tag), v1 $v1_ver ($v1_tag)"
  else
    warn "GitHub API tidak terjangkau — memakai versi pin bawaan script (v2 $v2_ver, v1 $v1_ver)."
  fi
fi

case "$TARGET" in
  v2)   install_one "v2" "$v2_ver" "" "$v2_tag" ;;
  v1)   install_one "v1" "$v1_ver" "symlink" "$v1_tag" ;;
  both)
    install_one "v2" "$v2_ver" "" "$v2_tag"
    # v1 berdampingan: JANGAN buat symlink — perintah 'opencode' milik v2,
    # v1 dipanggil dengan 'opencode1'.
    if [ "$FORCE_CONFLICTS" -eq 0 ]; then
      warn "Mode berdampingan: memasang v1 dengan --force-conflicts (metadata sebagian build v2 menyatakan konflik dengan opencode1)."
      FORCE_CONFLICTS=1
    fi
    install_one "v1" "$v1_ver" "" "$v1_tag"
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
