#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
    bash <(wget -qO- https://get.docker.com)
fi

docker_user="${SUDO_USER:-$USER}"

if ! getent group docker >/dev/null 2>&1; then
    sudo groupadd docker
fi

if ! id -nG "$docker_user" | tr ' ' '\n' | grep -qx docker; then
    sudo usermod -aG docker "$docker_user"
fi
