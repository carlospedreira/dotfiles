#!/usr/bin/env bash
set -euo pipefail

command -v devpod >/dev/null 2>&1 || exit 0

devpod context set-options -o SSH_CONFIG_PATH=~/.ssh/config.d/devpod
