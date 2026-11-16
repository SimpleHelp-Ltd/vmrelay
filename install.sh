#!/usr/bin/env bash
# Copyright 2026 SimpleHelp
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

version="0.2.53"
base_url="https://tools.simplehelp.io/vmrelay/$version"
install_dir="${VMRELAY_INSTALL_DIR:-/usr/local/bin}"

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"
case "$os" in
  darwin|linux) ;;
  *) echo "Unsupported OS: $os" >&2; exit 1 ;;
esac

case "$arch" in
  x86_64|amd64) arch="amd64" ;;
  arm64|aarch64) arch="arm64" ;;
  *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
esac

asset="vmrelay_${os}_${arch}.tar.gz"
url="$base_url/$asset"
case "$os/$arch" in
  darwin/amd64) expected_sha256="87490766b9672d4443d1df3368254d048d2e223b64771a439400cde39dac8c9f" ;;
  darwin/arm64) expected_sha256="2d4a10c8b5eba8012284a0e010bdfb655f9d31e6e4c248d16ffec1616ff66286" ;;
  linux/amd64) expected_sha256="9f7246c00037daca133f8e5625334e9e8b7511d14a2a2e196f26f246212c8d23" ;;
  linux/arm64) expected_sha256="e713f4ee7eb46a3c71fd9ca404ee23d145fca139ddb92bafa0217b24bf9ce346" ;;
esac

if command -v sha256sum >/dev/null 2>&1; then
  checksum_tool="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  checksum_tool="shasum"
else
  echo "A SHA-256 tool is required: install sha256sum or shasum." >&2
  exit 1
fi
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -fL "$url" -o "$tmp/$asset"
if [ "$checksum_tool" = "sha256sum" ]; then
  actual_sha256="$(sha256sum "$tmp/$asset")"
else
  actual_sha256="$(shasum -a 256 "$tmp/$asset")"
fi
actual_sha256="${actual_sha256%% *}"
if [ "$actual_sha256" != "$expected_sha256" ]; then
  echo "VMRelay download failed SHA-256 verification; installation unchanged." >&2
  exit 1
fi

tar -xzf "$tmp/$asset" -C "$tmp"

mkdir -p "$install_dir" 2>/dev/null || true
if [ -w "$install_dir" ]; then
  install -m 0755 "$tmp/vmrelay" "$install_dir/vmrelay"
else
  sudo install -m 0755 "$tmp/vmrelay" "$install_dir/vmrelay"
fi

"$install_dir/vmrelay" --version
