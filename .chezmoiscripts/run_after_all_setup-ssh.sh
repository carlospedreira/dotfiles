#!/usr/bin/env bash
set -euo pipefail

ssh_dir="$HOME/.ssh"
rsa_key="$ssh_dir/id_rsa"
ed25519_key="$ssh_dir/id_ed25519"
default_key_comment="$(hostname)"

if [[ -f "$rsa_key" && -f "$ed25519_key" ]]; then
    exit 0
fi

mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"

echo "Enter a passphrase for new SSH keys."
echo "Leave it empty to create keys without a passphrase."

while true; do
    read -rs -p "Passphrase: " passphrase </dev/tty
    echo >/dev/tty
    read -rs -p "Confirm passphrase: " passphrase_confirm </dev/tty
    echo >/dev/tty

    if [[ "$passphrase" == "$passphrase_confirm" ]]; then
        break
    fi

    echo "Passphrases do not match. Please try again." >/dev/tty
done

printf "SSH key comment [%s]: " "$default_key_comment" >/dev/tty
IFS= read -r key_comment </dev/tty
key_comment="${key_comment:-$default_key_comment}"

if [[ ! -f "$rsa_key" ]]; then
    ssh-keygen -t rsa -b 4096 -f "$rsa_key" -N "$passphrase" -C "$key_comment"
fi

if [[ ! -f "$ed25519_key" ]]; then
    ssh-keygen -t ed25519 -f "$ed25519_key" -N "$passphrase" -C "$key_comment"
fi
