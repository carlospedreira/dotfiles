# Dotfiles simplification and Ansible migration plan

## Goal

Split responsibilities cleanly:

- `dotfiles` remains a chezmoi-managed configuration repository.
- A new Ansible repository owns machine state, installed tools, services, host setup, and appliance configuration.

Working name for the new repository: `ansible`.

This name is acceptable for now because this is a personal repository and the purpose is obvious. If it later grows beyond Ansible-only content, rename/recreate it as `machine-config` or `systems`.

---

## Current state observed in `dotfiles`

The current repository still mixes configuration with installation and machine setup.

Examples:

- `README.md` bootstraps chezmoi directly with `chezmoi init --apply carlospedreira` and has a special `profile=container` flow.
- `.chezmoiignore` contains logic for OS/profile-specific install scripts.
- `dot_config/homebrew/Brewfile` contains Darwin application/tool installation state.
- `dot_config/mise/config.toml` contains tool installation state.
- `.chezmoiscripts` contains machine-changing scripts for SSH keys, Docker, DevPod, Tailscale, and Docker group setup.

Target direction: remove install/machine-state behavior from chezmoi and move it to Ansible.

---

## Final ownership model

### Ansible owns

- Installed tools and applications.
- Homebrew installation and Brewfile execution.
- mise installation and tool manifests.
- Docker/Podman/container host setup.
- SSH server hardening.
- Hostnames for appliance machines.
- Tailscale installation where explicitly required.
- Profile-specific machine setup.

### Chezmoi owns

- User configuration files.
- Shell configuration files.
- Git configuration.
- SSH client configuration.
- Application configuration files.
- Aliases and functions.

### Chezmoi does not own

- Install scripts.
- Brewfile.
- mise config.
- Package installation.
- Service setup.
- Docker/Podman setup.
- SSH server hardening.

---

## Target repositories

### `dotfiles`

Purpose: personal configuration only.

Keep examples:

```text
.zshrc
.zshenv
.gitconfig
.ssh/config
.ssh/config.d/machines
application config files
editor config files
aliases/functions
```

Remove or migrate examples:

```text
.chezmoiscripts/
.config/homebrew/Brewfile
.config/mise/config.toml
install hooks
setup hooks
package manager scripts
```

### `ansible`

Purpose: machine state and system setup.

Initial structure:

```text
ansible/
  ansible.cfg
  inventory.yml

  playbooks/
    darwin.yml
    ubuntu.yml
    fedora.yml
    wsl.yml
    raspberry.yml

  roles/
    base/
    ssh/
    mise/

    darwin/
    ubuntu/
    fedora/
    wsl/
    raspberry/
```

---

## Machine model

### Darwin

Role: personal workstation and Ansible control plane.

Darwin is the only machine that gets the personal environment.

The `darwin` role owns:

- zsh installation and login shell state.
- Homebrew installation.
- Darwin Brewfile.
- Darwin mise config.
- mise install for personal tools.
- chezmoi installation and update/apply.
- DevPod installation.
- Tailscale installation.
- Desktop applications.
- Darwin-specific setup.

Darwin hostname remains manual.

### Ubuntu

Role: appliance-style development host.

Playbook roles:

```yaml
roles:
  - base
  - ssh
  - ubuntu
  - mise
```

No chezmoi. No personal shell setup.

### Fedora

Role: appliance-style services/container host.

Playbook roles:

```yaml
roles:
  - base
  - ssh
  - fedora
  - mise
```

Notes:

- Fedora will eventually use a separate `containers` user for container runtime work.
- Do not focus on that branch in the first pass.
- Tailscale on Fedora is undecided and out of scope for now.

### WSL

Role: appliance-style DevPod target behind Windows VPN.

Playbook roles:

```yaml
roles:
  - base
  - ssh
  - wsl
  - mise
```

Important decisions:

- DevPod runs on Darwin, not inside WSL.
- WSL is the remote Linux target.
- WSL uses Docker Desktop on Windows.
- Do not install Docker Engine inside WSL.
- WSL should have SSH and Docker access.

### Raspberry

Role: redundant appliance/service pair.

Hosts:

```text
raspberry
blackberry
```

Playbook roles:

```yaml
roles:
  - base
  - ssh
  - raspberry
  - mise
```

The `raspberry` role owns Tailscale installation.

The two Raspberry Pi hosts should remain copies of each other for redundancy.

---

## Inventory model

Use a single inventory file initially.

```yaml
all:
  children:
    darwin:
      hosts:
        darwin:
          ansible_connection: local

    ubuntu:
      hosts:
        ubuntu:

    fedora:
      hosts:
        fedora:

    wsl:
      hosts:
        wsl:

    raspberry:
      hosts:
        raspberry:
        blackberry:
```

Rules:

- Inventory defines profile membership.
- SSH config defines connection details.
- Remote host names should be SSH aliases.
- Darwin must be applied first so chezmoi can create SSH aliases.

---

## SSH model

Darwin is the control plane.

Decisions:

- Use one Darwin-owned SSH private key.
- Remote machines receive only Darwin's public key.
- Remote machines do not SSH into each other.
- SSH aliases live in chezmoi.
- Use `~/.ssh/config.d/machines` for managed host aliases.

Chezmoi should manage something like:

```sshconfig
Include ~/.ssh/config.d/*
```

and:

```sshconfig
Host ubuntu
  HostName <stable-lan-ip>
  User carlos
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

Host fedora
  HostName <stable-lan-ip>
  User carlos
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

Host wsl
  HostName <stable-lan-ip>
  User carlos
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

Host raspberry
  HostName <stable-lan-ip>
  User carlos
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes

Host blackberry
  HostName <stable-lan-ip>
  User carlos
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
```

### SSH role

Appliance-only.

The `ssh` role should:

- Install `openssh-server`.
- Ensure SSH service is enabled/running where applicable.
- Harden SSH server configuration.
- Validate configuration.
- Reload/restart SSH automatically when validation passes.
- Not manage `authorized_keys`.

Use a drop-in file:

```text
/etc/ssh/sshd_config.d/00-machine-config.conf
```

Policy:

```sshconfig
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

Do not remove vendor drop-ins.

---

## Shared roles

### `base`

Appliance-only.

Purpose: minimal OS prerequisites.

Install:

```text
git
curl
ca-certificates
tar
unzip
vim
```

Rules:

- May update package metadata as part of installing packages.
- Must not run system upgrades.
- Must not install convenience tools.

Explicitly excluded:

```text
htop
btop
rsync
eza
zoxide
fzf
neovim
PowerShell
dotnet
Docker
Podman
Caddy
```

### `ssh`

See SSH model above.

### `mise`

Appliance-only.

Purpose: minimal coding/debugging toolchain.

The `mise` role should:

- Install mise per SSH/admin user.
- Write `~/.config/mise/config.toml`.
- Overwrite that file every run.
- Run `mise install`.

Use one shared appliance config across Ubuntu, Fedora, WSL, Raspberry, and Blackberry.

Initial appliance tool intent:

```toml
[tools]
node = "22"
"npm:@anthropic-ai/claude-code" = "latest"
"npm:@openai/codex" = "latest"
"npm:opencode-ai" = "latest"
rg = "latest"
jq = "latest"
```

Versioning rule:

- Pin major versions for runtime foundations like Node.
- Use `latest` for npm-based coding agents initially.
- Keep the appliance config minimal.

---

## Darwin role details

`roles/darwin` should be self-contained.

It should own:

```text
Homebrew installation
Brewfile copy and brew bundle
mise installation
Darwin mise config copy and mise install
chezmoi installation
chezmoi update/apply
zsh login shell state
DevPod installation
Tailscale installation
Darwin desktop applications
```

Recommended internal structure:

```text
roles/darwin/
  tasks/
    main.yml
  files/
    Brewfile
  templates/
    mise.toml.j2
```

Copy destinations:

```text
~/.config/homebrew/Brewfile
~/.config/mise/config.toml
```

Darwin's Brewfile should include the desktop apps currently in `dot_config/homebrew/Brewfile`.

Darwin's mise config should include the richer personal development toolchain currently in `dot_config/mise/config.toml`.

---

## Dotfiles cleanup plan

### Phase 1: Freeze ownership rules

Document in `dotfiles/README.md` that dotfiles owns only configuration.

Remove the idea that chezmoi is the machine bootstrapper.

### Phase 2: Move manifests to Ansible

Move from dotfiles to Ansible:

```text
dot_config/homebrew/Brewfile
  -> roles/darwin/files/Brewfile

dot_config/mise/config.toml
  -> roles/darwin/templates/mise.toml.j2
  -> roles/mise/templates/config.toml.j2 for appliance minimal config
```

After this, remove those files from dotfiles.

### Phase 3: Remove install scripts from chezmoi

Migrate or delete `.chezmoiscripts` that perform installation or machine mutation.

Known scripts to migrate/remove:

```text
run_after_all_setup-devpod.sh
run_after_all_setup-ssh.sh
run_before_linux_install-docker.sh
run_before_linux_install-devpod.sh
run_before_linux_install-tailscale.sh
run_after_linux_setup-docker.sh
```

Target ownership:

```text
DevPod setup       -> darwin role
SSH key setup      -> bootstrap/open question, not chezmoi
Docker install     -> ubuntu or wsl/fedora profile decision, not chezmoi
Tailscale install  -> darwin and raspberry roles
Docker group setup -> relevant profile role
```

### Phase 4: Simplify `.chezmoiignore`

Remove OS/profile-specific install-script filtering once scripts are gone.

Keep ignores only for files that should genuinely not be applied.

### Phase 5: Keep SSH client config in chezmoi

Move toward:

```text
~/.ssh/config
~/.ssh/config.d/machines
```

Chezmoi owns SSH client aliases.

Ansible consumes those aliases through inventory.

---

## New Ansible repo creation plan

### Step 1: Create repo

Create a new repository:

```text
carlospedreira/ansible
```

### Step 2: Add skeleton

Create:

```text
ansible.cfg
inventory.yml
playbooks/darwin.yml
playbooks/ubuntu.yml
playbooks/fedora.yml
playbooks/wsl.yml
playbooks/raspberry.yml
roles/base/tasks/main.yml
roles/ssh/tasks/main.yml
roles/mise/tasks/main.yml
roles/mise/templates/config.toml.j2
roles/darwin/tasks/main.yml
roles/darwin/files/Brewfile
roles/darwin/templates/mise.toml.j2
roles/ubuntu/tasks/main.yml
roles/fedora/tasks/main.yml
roles/wsl/tasks/main.yml
roles/raspberry/tasks/main.yml
```

### Step 3: Implement in safe order

Implement first:

1. `inventory.yml`
2. `base`
3. `mise`
4. `darwin`
5. `ssh`
6. profile roles

Reason: avoid breaking SSH first. Get low-risk package/tooling setup working before hardening access.

### Step 4: Run Darwin first

Darwin must be applied first because it creates the SSH client config through chezmoi.

```sh
ansible-playbook -i inventory.yml playbooks/darwin.yml
```

Then remote hosts:

```sh
ansible-playbook -i inventory.yml playbooks/ubuntu.yml
ansible-playbook -i inventory.yml playbooks/fedora.yml
ansible-playbook -i inventory.yml playbooks/wsl.yml
ansible-playbook -i inventory.yml playbooks/raspberry.yml
```

---

## Explicitly out of scope for now

Do not implement yet:

```text
bootstrap scripts
firewall management
timezone management
locale management
system upgrades
Tailscale on Fedora
Docker Engine inside WSL
authorized_keys management
Darwin hostname management
per-machine Raspberry divergence
```

---

## Acceptance criteria

### Dotfiles is simplified when

- It contains no install scripts.
- It contains no Brewfile.
- It contains no mise tool manifest.
- It owns SSH client config, zsh config, git config, and app config only.
- README describes dotfiles as configuration-only.

### Ansible repo is useful when

- Darwin can be configured from `playbooks/darwin.yml`.
- Appliances can run `base`, `ssh`, profile role, and `mise`.
- Appliance mise config is minimal and shared.
- SSH hardening uses `/etc/ssh/sshd_config.d/00-machine-config.conf`.
- Raspberry and Blackberry receive the same raspberry profile.
- WSL is configured as a DevPod target and does not install DevPod or Docker Engine.
