#!/usr/bin/env bash
set -euo pipefail

if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools — accept the prompt when it appears."
    xcode-select --install >/dev/null 2>&1 || true
    until xcode-select -p >/dev/null 2>&1; do
        sleep 5
    done
    echo "Xcode Command Line Tools ready."
fi

if ! command -v brew >/dev/null 2>&1; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew_bin=/opt/homebrew/bin/brew
[ -x "$brew_bin" ] || brew_bin=/usr/local/bin/brew
eval "$("$brew_bin" shellenv)"
brew install chezmoi

cat <<EOF
Bootstrap complete.

Run the following commands:
  eval "\$($brew_bin shellenv)"
  chezmoi init --apply carlospedreira
EOF
