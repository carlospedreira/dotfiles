#!/usr/bin/env bash
set -euo pipefail

if ! command -v chezmoi >/dev/null 2>&1; then
  mkdir -p "$HOME/.local/bin"
  sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

chezmoi \
  --source "$PWD" \
  init \
  --apply \
  --override-data '{"profile":"container"}'
