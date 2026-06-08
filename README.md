# Dotfiles

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply carlospedreira
```

For containers:

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply carlospedreira --override-data '{"profile":"container"}'
```
