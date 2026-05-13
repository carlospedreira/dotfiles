#!/usr/bin/env bash
# One-liner: bash -c "$(curl -fsSL https://raw.githubusercontent.com/carlospedreira/dotfiles/main/bootstrap/ubuntu.sh)"
set -euo pipefail

sudo apt-get update
sudo apt-get install -y build-essential curl file git

if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install chezmoi

chezmoi init --apply carlospedreira

echo "Bootstrap complete."
