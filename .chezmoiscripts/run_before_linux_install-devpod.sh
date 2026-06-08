#!/usr/bin/env bash
set -euo pipefail

command -v devpod >/dev/null 2>&1 && exit 0

curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
sudo install -c -m 0755 devpod /usr/local/bin
rm -f devpod
