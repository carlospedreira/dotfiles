FROM mcr.microsoft.com/devcontainers/base:ubuntu26.04

ARG USERNAME=vscode

LABEL org.opencontainers.image.source="https://github.com/carlospedreira/dotfiles"

USER root
COPY --chown=${USERNAME}:${USERNAME} . /home/${USERNAME}/.local/share/chezmoi

USER ${USERNAME}
WORKDIR /home/${USERNAME}/.local/share/chezmoi
RUN if ! command -v chezmoi >/dev/null 2>&1; then \
        mkdir -p "$HOME/.local/bin"; \
        sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b "$HOME/.local/bin"; \
    fi \
    && PATH="$HOME/.local/bin:$PATH" chezmoi \
        --source "$PWD" \
        init \
        --apply \
        --promptString profile=container \
    && rm -rf \
        "$HOME/.npm" \
        "$HOME/.cache/mise" \
        "$HOME/.local/share/mise/downloads"

WORKDIR /workspaces
