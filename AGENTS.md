# AGENTS.md

## Repository Rules

- This is a chezmoi-managed dotfiles repo. Prefer small, explicit changes that match existing file naming and script conventions.
- Do not revert, remove, stage, or commit unrelated worktree changes.

## Chezmoi Scripts

- Use `run_before_*` for prerequisites that must exist before chezmoi applies the rest of the files.
- Use `run_after_*` for idempotent follow-up setup that can run on every apply.
- Use `run_onchange_after_*` only when the script should rerun because relevant input content changed.
- Keep installer scripts simple and idempotent: check `command -v <tool>`, exit if present, otherwise run the official installer.
- Avoid extra post-install probing unless the surrounding scripts already use that pattern or a real failure mode requires it.
- Use clear names that describe the operation and target, such as `install-mise`, `setup-mise`, `install-homebrew`, and `setup-homebrew`.

## Validation

- Run `bash -n` for changed shell scripts.
