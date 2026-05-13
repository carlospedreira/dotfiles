#!/usr/bin/env bash
# One-liner: bash -c "$(curl -fsSL https://raw.githubusercontent.com/carlospedreira/dotfiles/main/bootstrap/macos-set-hostname.sh)" -- <visible-name> [network-name]
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 <visible-name> [network-name]" >&2
    echo "  visible-name:  ComputerName (e.g. 'Blackstone')" >&2
    echo "  network-name:  HostName/LocalHostName (defaults to lowercased visible-name with spaces as '-')" >&2
    exit 1
fi

if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script only runs on macOS." >&2
    exit 1
fi

computer_name="$1"
if [[ $# -eq 2 ]]; then
    network_name="$2"
else
    network_name="$(echo "$computer_name" | tr '[:upper:] ' '[:lower:]-')"
fi

sudo scutil --set ComputerName "$computer_name"
sudo scutil --set HostName "$network_name"
sudo scutil --set LocalHostName "$network_name"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$network_name"

sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo "Hostname updated:"
echo "  ComputerName:  $(scutil --get ComputerName)"
echo "  HostName:      $(scutil --get HostName)"
echo "  LocalHostName: $(scutil --get LocalHostName)"
