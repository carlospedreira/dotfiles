#!/usr/bin/env bash
set -euo pipefail

xcode-select --install >/dev/null 2>&1 || true

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
