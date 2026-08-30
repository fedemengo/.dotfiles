#!/usr/bin/env bash
#
# Fetch prebuilt binaries from GitHub releases into ~/.local/bin.
#
# These are downloaded artifacts rather than build products, so they are
# deliberately not committed. Contrast ../bin, which the Makefile populates by
# compiling sources kept in this repo.
#
# Usage:
#   ./install-binaries.sh          # install everything
#   ./install-binaries.sh nvtop    # install just one
#   ./install-binaries.sh --list   # show what is available

set -euo pipefail

DEST="${DEST:-$HOME/.local/bin}"

# "<name> <url>", one per line. Point URLs at a release's "latest" asset so that
# re-running this picks up new versions without editing anything here.
BINARIES=(
  "nvtop https://github.com/fedemengo/nvtop/releases/latest/download/nvtop-linux-x86_64"
)

# The binaries above are all Linux x86_64. Exit 0 rather than 1 so that calling
# this from a bootstrap chain on a mac skips it instead of aborting the run.
require_supported_platform() {
  local platform
  platform="$(uname -s)/$(uname -m)"
  if [ "$platform" != "Linux/x86_64" ]; then
    printf 'install-binaries: prebuilt binaries are Linux/x86_64 only, skipping (%s)\n' "$platform" >&2
    exit 0
  fi
}

list_binaries() {
  local entry name url
  for entry in "${BINARIES[@]}"; do
    read -r name url <<<"$entry"
    printf '%-12s %s\n' "$name" "$url"
  done
}

install_one() {
  local name="$1" url="$2" tmp="$DEST/.$name.download"

  if ! curl -fL --retry 3 --connect-timeout 10 -o "$tmp" "$url"; then
    rm -f "$tmp"
    printf 'install-binaries: %s: download failed, existing binary left untouched\n' "$name" >&2
    return 1
  fi

  chmod 755 "$tmp"
  # Rename within the same directory, so a running instance keeps the old inode
  # and nothing ever observes a half-written file on PATH.
  mv -f "$tmp" "$DEST/$name"
  printf 'install-binaries: %s -> %s (%s)\n' "$name" "$DEST/$name" "$(du -h "$DEST/$name" | cut -f1)"
}

main() {
  if [ "${1:-}" = "--list" ]; then
    list_binaries
    return 0
  fi

  require_supported_platform
  mkdir -p "$DEST"

  local entry name url rc=0 matched=0
  for entry in "${BINARIES[@]}"; do
    read -r name url <<<"$entry"
    if [ "$#" -gt 0 ] && ! printf '%s\n' "$@" | grep -qxF "$name"; then
      continue
    fi
    matched=1
    install_one "$name" "$url" || rc=1
  done

  if [ "$#" -gt 0 ] && [ "$matched" -eq 0 ]; then
    printf 'install-binaries: no binary named %s; try --list\n' "$*" >&2
    return 1
  fi
  return "$rc"
}

main "$@"
