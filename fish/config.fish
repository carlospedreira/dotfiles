if status is-interactive
    starship init fish | source

    alias clone="~/.local/bin/clone-azure-repos.sh"
    alias pull="~/.local/bin/git-pull-all.sh"
    alias ls="eza -lh --icons --group-directories-first"
    alias ll="eza -lh --icons --group-directories-first"
    alias la="eza -lah --icons --group-directories-first"
    alias lt="eza --tree --level=2 --icons"
    alias cat="bat"
end
