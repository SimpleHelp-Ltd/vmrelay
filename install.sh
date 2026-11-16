#!/usr/bin/env bash
# Copyright 2026 SimpleHelp
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

version="0.2.54"
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
  darwin/amd64) expected_sha256="93338d87fd135141b2a4db3e75af2ac6e7aa4393c1933102dffdf548c5b0adf5" ;;
  darwin/arm64) expected_sha256="5d0b8403e399a28090f0efb3990caadd91fb5ee0407f6bce8aa580df6e4a990b" ;;
  linux/amd64) expected_sha256="1f26518346f48b192d5c818a298625c7d6bfd72653b17d962f34f15af98498f3" ;;
  linux/arm64) expected_sha256="281e3286042ad690c2b00f48e8b1b0530b003b0e23f02f8ca5ec10534bd6f43e" ;;
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
