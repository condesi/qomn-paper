#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────
# QOMN — Local Installation Script
#
# Installs the QOMN runtime from source on a Linux or macOS system.
# After installation, the full paper can be reproduced locally without
# depending on the public API.
#
# Requirements: git, curl, a C compiler, ~2 GB disk, ~4 GB RAM for build
# Runtime: 5–15 minutes depending on hardware
#
# Tested on:
#   - Ubuntu 22.04 / 24.04
#   - Debian 12
#   - macOS 13+ (Apple Silicon or Intel)
#
# Usage:
#   bash scripts/install.sh [--prefix /opt/qomn]
# ─────────────────────────────────────────────────────────────────────────

set -eu

PREFIX="${PREFIX:-$HOME/.local/qomn}"
QOMN_GIT="https://github.com/condesi/qomn.git"
STDLIB_GIT="https://github.com/condesi/crysl-lang.git"   # stdlib plans

log()  { printf '\033[1;36m[install]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

# ─── 1. Check prerequisites ────────────────────────────────────────────
log "Step 1/6: Checking prerequisites..."

command -v git >/dev/null 2>&1 || die "git is required but not installed."
command -v curl >/dev/null 2>&1 || die "curl is required but not installed."

# Rust toolchain
if ! command -v cargo >/dev/null 2>&1; then
  log "Rust toolchain not found. Installing via rustup (non-interactive)..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
  # shellcheck disable=SC1091
  . "$HOME/.cargo/env"
fi

RUST_VERSION=$(rustc --version | awk '{print $2}')
log "Rust detected: $RUST_VERSION"

# ─── 2. Clone source ───────────────────────────────────────────────────
log "Step 2/6: Cloning QOMN source into $PREFIX ..."
mkdir -p "$PREFIX"
if [[ -d "$PREFIX/qomn/.git" ]]; then
  log "Existing checkout found. Updating..."
  git -C "$PREFIX/qomn" pull --ff-only
else
  git clone --depth 1 "$QOMN_GIT" "$PREFIX/qomn"
fi

# ─── 3. Clone standard library (engineering plans) ─────────────────────
log "Step 3/6: Cloning standard library (engineering plans)..."
if [[ -d "$PREFIX/stdlib/.git" ]]; then
  git -C "$PREFIX/stdlib" pull --ff-only
else
  git clone --depth 1 "$STDLIB_GIT" "$PREFIX/stdlib"
fi

# ─── 4. Build release binary ───────────────────────────────────────────
log "Step 4/6: Building QOMN (release profile)..."
cd "$PREFIX/qomn"
cargo build --release

BINARY="$PREFIX/qomn/target/release/qomn"
if [[ ! -x "$BINARY" ]]; then
  die "Build succeeded but binary not found at $BINARY"
fi

log "Binary size: $(du -h "$BINARY" | awk '{print $1}')"

# ─── 5. Smoke test ─────────────────────────────────────────────────────
log "Step 5/6: Running smoke test (run a plan locally)..."

# Start the runtime on a local port
"$BINARY" server --port 9001 > /tmp/qomn-install.log 2>&1 &
SERVER_PID=$!
cleanup() { kill "$SERVER_PID" 2>/dev/null || true; }
trap cleanup EXIT

# Wait for server ready
for _ in $(seq 1 20); do
  if curl -s -m 1 http://127.0.0.1:9001/api/health >/dev/null 2>&1; then
    break
  fi
  sleep 0.5
done

SMOKE=$(curl -s -m 5 -X POST http://127.0.0.1:9001/api/plan/execute \
  -H "Content-Type: application/json" \
  -d '{"plan":"plan_pump_sizing","params":{"Q_gpm":500,"P_psi":100,"eff":0.75}}')

if echo "$SMOKE" | grep -q '"hp_required"'; then
  log "Smoke test passed. Sample output:"
  echo "  $SMOKE" | head -c 200
  echo
else
  die "Smoke test failed. Server log:\n$(cat /tmp/qomn-install.log)"
fi

# ─── 6. Summary ────────────────────────────────────────────────────────
log "Step 6/6: Installation complete."
cat <<EOF

─────────────────────────────────────────────────────────────
  QOMN Local Installation Summary
─────────────────────────────────────────────────────────────
  Prefix:   $PREFIX
  Binary:   $BINARY
  Stdlib:   $PREFIX/stdlib
  Version:  $("$BINARY" --version 2>/dev/null || echo 'n/a')

  To start the server:
    $BINARY server --port 9001

  To reproduce the paper against your local instance:
    QOMN_API_BASE=http://127.0.0.1:9001 \\
      bash $(dirname "$0")/reproduce.sh
─────────────────────────────────────────────────────────────

EOF
