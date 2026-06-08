#!/usr/bin/env bash
set -euo pipefail

if command -v tailscale >/dev/null 2>&1; then
    exit 0
fi

curl -fsSL https://tailscale.com/install.sh | sh
