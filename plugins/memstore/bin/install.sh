#!/bin/sh
# Installs memstore-client, what the memstore plugins run (the sign-in, the hooks and the MCP bridge, a few MB), from
# the public releases of A79-ai/memstore-plugins, for this machine: Apple Silicon macOS, or Linux on arm64 or x86_64.
#
#   curl -fsSL https://raw.githubusercontent.com/A79-ai/memstore-plugins/main/install.sh | sh
#
#   MEMSTORE_VERSION      a release tag such as v0.1.0 (default: the latest release)
#   MEMSTORE_INSTALL_DIR  where it goes (default: ~/.local/bin)
#   MEMSTORE_CLIENT_REPO  the repository whose releases hold it (default: A79-ai/memstore-plugins)
#   MEMSTORE_INSTALL_FROM a directory holding the release's files, instead of downloading them (for tests)
set -eu
repo=${MEMSTORE_CLIENT_REPO:-A79-ai/memstore-plugins}
dir=${MEMSTORE_INSTALL_DIR:-$HOME/.local/bin}

case "$(uname -s)" in
  Darwin) os=apple-darwin ;;
  Linux) os=unknown-linux-gnu ;;
  *) echo "memstore-client builds for macOS and Linux only, not $(uname -s)" >&2; exit 1 ;;
esac
case "$(uname -m)" in
  arm64 | aarch64) arch=aarch64 ;;
  x86_64 | amd64) arch=x86_64 ;;
  *) echo "memstore-client builds for arm64 and x86_64 only, not $(uname -m)" >&2; exit 1 ;;
esac
if [ "$os" = apple-darwin ] && [ "$arch" = x86_64 ]; then
  # A shell under Rosetta reports x86_64 on Apple Silicon; the arm64 build runs there natively.
  if [ "$(sysctl -n hw.optional.arm64 2>/dev/null)" = 1 ]; then
    arch=aarch64
  else
    echo "memstore-client builds for Apple Silicon Macs only" >&2
    exit 1
  fi
fi
asset=memstore-client-$arch-$os.tar.gz

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
if [ -n "${MEMSTORE_INSTALL_FROM:-}" ]; then
  cp "$MEMSTORE_INSTALL_FROM/$asset" "$MEMSTORE_INSTALL_FROM/$asset.sha256" "$tmp/"
else
  case "${MEMSTORE_VERSION:-latest}" in
    latest) base=https://github.com/$repo/releases/latest/download ;;
    *) base=https://github.com/$repo/releases/download/$MEMSTORE_VERSION ;;
  esac
  for f in "$asset" "$asset.sha256"; do
    if command -v curl >/dev/null; then
      curl -fsSL --retry 3 -o "$tmp/$f" "$base/$f"
    else
      wget -q -O "$tmp/$f" "$base/$f"
    fi || { echo "couldn't download $base/$f" >&2; exit 1; }
  done
fi

# The checksum file names the archive as it was built: compare the hashes alone.
want=$(cut -d' ' -f1 "$tmp/$asset.sha256")
if command -v sha256sum >/dev/null; then
  got=$(sha256sum "$tmp/$asset" | cut -d' ' -f1)
else
  got=$(shasum -a 256 "$tmp/$asset" | cut -d' ' -f1)
fi
[ "$want" = "$got" ] || { echo "$asset doesn't match its checksum ($got, not $want)" >&2; exit 1; }

mkdir -p "$tmp/out" "$dir"
tar -xzf "$tmp/$asset" -C "$tmp/out"
# Moved into place whole: a hook running the old copy keeps it, the next one runs the new.
mv "$tmp/out/memstore-client" "$dir/memstore-client.new"
chmod 755 "$dir/memstore-client.new"
# Not signed yet: a download is quarantined, and Gatekeeper would refuse it.
[ "$os" = apple-darwin ] && xattr -d com.apple.quarantine "$dir/memstore-client.new" 2>/dev/null || true
mv -f "$dir/memstore-client.new" "$dir/memstore-client"
echo "installed $("$dir/memstore-client" --version) to $dir/memstore-client"
case ":$PATH:" in
  *":$dir:"*) ;;
  *) echo "(the plugins find it there; to run it yourself, add $dir to your PATH)" ;;
esac
echo "next: sign in with /memstore:login in Claude Code, or memstore-client join <your team's server> --org <your org>"
