if status is-interactive
    starship init fish | source

    alias ls="eza -lh --icons --group-directories-first"
    alias ll="eza -lh --icons --group-directories-first"
    alias la="eza -lah --icons --group-directories-first"
    alias lt="eza --tree --level=2 --icons"
    alias cat="bat"
    alias s="sesh picker"
    alias sc="sesh connect"
end
