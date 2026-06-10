#!/usr/bin/env bash
set -euo pipefail

if ! command -v sshd >/dev/null 2>&1 && [[ ! -x /usr/sbin/sshd ]]; then
    sudo apt install -y openssh-server
fi

sudo mkdir -p /etc/ssh/sshd_config.d
sudo tee /etc/ssh/sshd_config.d/99-wsl-ssh-port.conf >/dev/null <<'EOF'
AddressFamily inet
Port 2222
ListenAddress 0.0.0.0
EOF

sudo sshd -t
sudo systemctl enable --now ssh 2>/dev/null || sudo service ssh restart
