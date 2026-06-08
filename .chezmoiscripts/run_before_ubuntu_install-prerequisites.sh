#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt >/dev/null 2>&1; then
    exit 0
fi

sudo apt update
sudo apt install -y curl git ca-certificates libatomic1 libicu78 build-essential bubblewrap zsh
