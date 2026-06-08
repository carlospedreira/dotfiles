#!/usr/bin/env bash
set -euo pipefail

command -v zsh >/dev/null 2>&1 || exit 0
command -v chsh >/dev/null 2>&1 || exit 0

zsh_path="$(command -v zsh)"
user="$(id -un)"
current_shell="$(getent passwd "$user" | cut -d: -f7)"

if [[ "$current_shell" != "$zsh_path" ]]; then
    sudo chsh -s "$zsh_path" "$user"
fi
