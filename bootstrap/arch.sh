#!/usr/bin/env bash
set -euo pipefail

sudo pacman -Sy --noconfirm --needed base-devel curl git

if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$("$(command -v brew)" shellenv)"
brew install chezmoi bitwarden-cli

cat <<EOF
Bootstrap complete.

Run the following commands:
  eval "\$("\$(command -v brew)" shellenv)"
  bw login
  chezmoi init --apply carlospedreira
EOF
