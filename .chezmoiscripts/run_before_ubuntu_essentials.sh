#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y curl git ca-certificates libatomic1 libicu78 build-essential bubblewrap zsh
sudo apt autoremove -y
