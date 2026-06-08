#!/usr/bin/env bash
set -euo pipefail

command -v docker >/dev/null 2>&1 && exit 0

bash <(wget -qO- https://get.docker.com)
