#!/usr/bin/env bash
set -euo pipefail

command -v docker >/dev/null 2>&1 || exit 0

docker_user="${SUDO_USER:-$USER}"

if ! getent group docker >/dev/null 2>&1; then
    sudo groupadd docker
fi

if ! id -nG "$docker_user" | tr ' ' '\n' | grep -qx docker; then
    sudo usermod -aG docker "$docker_user"
fi
