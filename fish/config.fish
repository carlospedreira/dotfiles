fish_add_path -g ~/.local/bin

fish_add_path -g ~/.nvm/versions/node/*/bin

if status is-interactive
    starship init fish | source
    zoxide init fish | source

    alias cc="claude --dangerously-skip-permissions"
    alias ls="eza -lh --icons --group-directories-first"
    alias ll="eza -lh --icons --group-directories-first"
    alias la="eza -lah --icons --group-directories-first"
    alias lt="eza --tree --level=2 --icons"
    alias cat="bat"
    alias s="sesh picker -tc"
    alias sc="sesh connect"
end
