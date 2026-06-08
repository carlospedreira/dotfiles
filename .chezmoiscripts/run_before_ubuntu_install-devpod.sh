#!/usr/bin/env bash
set -euo pipefail

if command -v devpod >/dev/null 2>&1; then
    exit 0
fi

curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
sudo install -c -m 0755 devpod /usr/local/bin
rm -f devpod
