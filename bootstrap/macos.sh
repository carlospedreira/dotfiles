#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
    # Let the Homebrew installer handle Command Line Tools install
    # itself (via softwareupdate, with sudo) — no GUI dialog. Redirect
    # stdin from /dev/tty so the installer's interactive prompts work
    # even when this script is invoked via `curl | bash`.
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
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
