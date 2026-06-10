#!/usr/bin/env bash
set -euo pipefail

command -v crontab >/dev/null 2>&1 || exit 0
command -v docker >/dev/null 2>&1 || exit 0

docker_path="$(command -v docker)"
cron_begin="# chezmoi: begin devcontainer image pull"
cron_end="# chezmoi: end devcontainer image pull"
cron_entry="0 * * * * $docker_path pull ghcr.io/carlospedreira/devcontainer:latest >/dev/null"

current_cron="$(mktemp)"
next_cron="$(mktemp)"
target_cron="$(mktemp)"
trap 'rm -f "$current_cron" "$next_cron" "$target_cron"' EXIT

crontab -l >"$current_cron" 2>/dev/null || true

awk -v begin="$cron_begin" -v end="$cron_end" '
    $0 == begin {
        skip = 1
        next
    }

    $0 == end {
        skip = 0
        next
    }

    !skip {
        print
    }
' "$current_cron" >"$next_cron"

{
    cat "$next_cron"

    if [[ -s "$next_cron" ]]; then
        printf '\n'
    fi

    printf '%s\n%s\n%s\n' "$cron_begin" "$cron_entry" "$cron_end"
} >"$target_cron"

if cmp -s "$current_cron" "$target_cron"; then
    exit 0
fi

crontab "$target_cron"
