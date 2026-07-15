# Dotfiles

**Prerequisites:**

- Homebrew installed
- Chezmoi installed
- Zsh installed and set as the login shell

## Installation

Install and apply the dotfiles:

```sh
chezmoi init --apply carlospedreira
```

Open a new shell, then install the packages and applications:

```sh
brew bundle
```

## Ubuntu

Install Git and unzip:

```sh
sudo apt update && sudo apt install -y git unzip
```

Install Docker:

```sh
bash <(wget -qO- https://get.docker.com)
```
