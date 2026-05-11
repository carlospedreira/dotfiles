#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y build-essential curl file git

if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install chezmoi bitwarden-cli

cat <<EOF
Bootstrap complete.

Run the following commands:
  eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  bw login
  chezmoi init --apply carlospedreira
EOF
