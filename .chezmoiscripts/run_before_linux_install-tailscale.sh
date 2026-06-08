#!/usr/bin/env bash
set -euo pipefail

command -v tailscale >/dev/null 2>&1 && exit 0

curl -fsSL https://tailscale.com/install.sh | sh
