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

Install Git, unzip, and Zsh:

```sh
sudo apt update && sudo apt install -y git unzip zsh
```

Set Zsh as the login shell:

```sh
chsh -s /bin/zsh
```

Install Docker:

```sh
bash <(wget -qO- https://get.docker.com)
```
