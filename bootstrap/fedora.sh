#!/usr/bin/env bash
set -euo pipefail

sudo dnf install -y curl file git

if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install chezmoi

cat <<EOF
Bootstrap complete.

Run the following commands:
  eval "\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  chezmoi init --apply carlospedreira
EOF
