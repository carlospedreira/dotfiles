#!/usr/bin/env bash
set -euo pipefail

if ! command -v devpod >/dev/null 2>&1; then
    exit 0
fi

devpod context set-options -o SSH_CONFIG_PATH=~/.ssh/config.d/devpod
