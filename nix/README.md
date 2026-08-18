# Nix Configuration

Home Manager configuration using Nix flakes. Manages packages, program settings, and dotfile symlinks.

## Structure

```
nix/
├── user.nix                 # Target Linux user and home directory
└── modules/
    └── home/
        ├── default.nix      # Main home-manager entry point
        ├── packages.nix     # System-wide package list
        ├── dotfiles.nix     # Dotfile symlinks (starship, batto)
        └── programs/
            ├── default.nix  # Program module imports
            ├── claude.nix   # Claude Code/Codex settings and shared agent skills
            ├── direnv.nix   # [direnv](https://github.com/nix-community/nix-direnv) for per-directory env
            ├── ghostty.nix  # Ghostty terminal package + config
            ├── lazygit.nix  # Lazygit package + config
            ├── neovim.nix   # Neovim package + config
            ├── starship.nix # Starship prompt package
            ├── tmux.nix     # tmux package + config
            ├── vscode.nix   # VS Code package, extensions, formatters, and settings link
            ├── wezterm.nix  # WezTerm terminal package + config
            └── zsh.nix      # Deploys config for the host-installed Zsh
```

## Initial Setup

This repository assumes a multi-user Nix installation with `nix-daemon`.
Complete these steps in order before applying the Home Manager configuration.

### 1. Enable the Nix CLI and flakes for the user

Create the per-user Nix configuration directory, then open its configuration
file in an editor:

```bash
mkdir -p ~/.config/nix
${EDITOR:-vi} ~/.config/nix/nix.conf
```

Add the following setting to `~/.config/nix/nix.conf`. If the file already has
an `experimental-features` setting, add the missing feature names to that line
instead of creating a duplicate setting.

```ini
experimental-features = nix-command flakes
```

The `nix-command` and `flakes` features are still marked experimental by Nix and
are required by commands such as `nix run`, `nix store`, and `nix flake` used in
this repository.

Confirm that the user configuration is loaded:

```bash
nix config show | rg '^experimental-features = .*nix-command.*flakes|^experimental-features = .*flakes.*nix-command'
```

### 2. Configure the system-wide Numtide cache

Edit `/etc/nix/nix.conf` as root and add the following settings. Preserve any
existing values when adding the new substituter and public key.

```ini
extra-substituters = https://cache.numtide.com
extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
```

The Numtide cache is also required because this configuration installs Claude
Code and Codex from `numtide/llm-agents.nix`. Without it, Nix may build Codex
locally.

Do not work around the cache requirement by adding the regular user to
`trusted-users`. This flake relies on system-wide daemon configuration instead
of granting the user daemon-level trust.

### 3. Restart the Nix daemon

On a systemd-based multi-user Nix installation, restart the daemon so it reads
the updated `nix.conf`:

```bash
sudo systemctl restart nix-daemon.service
```

`systemctl daemon-reload` is not needed when only `nix.conf` changes; it reloads
systemd unit definitions, not Nix configuration. If the installation does not
provide `nix-daemon.service`, reboot or use the restart procedure provided by
that Nix installation.

### 4. Verify the daemon configuration

Run these commands as the regular user:

```bash
nix config show | rg '^substituters = .*https://cache.numtide.com'
nix config show | rg '^trusted-public-keys = .*niks3.numtide.com-1:'
```

Both commands must print a matching line before continuing.

### 5. Install the login shell

On Ubuntu or Debian, install zsh with the host package manager. A system
installation registers zsh in `/etc/shells`, allowing it to be selected as the
login shell while Home Manager manages only its user configuration.

```bash
sudo apt update
sudo apt install zsh
chsh -s /usr/bin/zsh
```

### 6. Configure the target user

Before the first activation, edit `nix/user.nix` and set `username` to the
Linux account that will use this configuration:

```nix
let
  username = "your-username";
in
{
  inherit username;
  homeDirectory = "/home/${username}";
}
```

`homeDirectory` is derived from the username for a conventional Linux home
directory. Set it explicitly if the account uses a different location. The
same values are used for the flake's Home Manager configuration name and the
Home Manager `home` options, so they cannot drift apart.

### 7. Apply the Home Manager configuration

```bash
nix run home-manager -- switch --flake ~/dotfiles
```

On a non-NixOS system with an NVIDIA GPU, this command alone does not finish the
GPU setup. Complete the next section and run the `sudo` command printed by Home
Manager.

## NVIDIA GPU Setup (non-NixOS)

The proprietary NVIDIA libraries built by Home Manager must exactly match the
driver installed on the host. Repeat this procedure after every host NVIDIA
driver update.

For the upstream behavior and additional options, see Home Manager's official
[GPU on non-NixOS systems](https://github.com/nix-community/home-manager/blob/master/docs/manual/usage/gpu-non-nixos.md)
guide.

### 1. Get the installed version and matching hash

Run this command as a single line. It reads the installed version with
`nvidia-smi`, prefetches the matching installer into the Nix store, and prints
both values in a form that can be copied into `default.nix`:

```bash
v=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -1 | xargs); h=$(nix store prefetch-file --json "https://download.nvidia.com/XFree86/Linux-x86_64/$v/NVIDIA-Linux-x86_64-$v.run" | jq -r .hash); printf 'version = "%s";\nsha256 = "%s";\n' "$v" "$h"
```

Example output:

```nix
version = "595.84";
sha256 = "sha256-mcQE5SExvye8ptoCaNzOPr7cenOrF0BxqZXPGmxeugY=";
```

The command targets `x86_64-linux`. On an ARM system, replace both occurrences
of `Linux-x86_64` with `Linux-aarch64`.

### 2. Update `default.nix`

Update both values in `nix/modules/home/default.nix`:

```nix
targets.genericLinux.gpu = {
  enable = true;
  nvidia = {
    enable = true;
    version = "595.84";
    sha256 = "sha256-mcQE5SExvye8ptoCaNzOPr7cenOrF0BxqZXPGmxeugY=";
  };
};
```

### 3. Apply Home Manager and run the GPU setup command

```bash
nix run home-manager -- switch --flake ~/dotfiles
```

Home Manager compares the new GPU environment with `/run/opengl-driver`. When
setup or an update is required, it prints a command similar to:

```text
GPU drivers require an update, run
  sudo /nix/store/HASH-non-nixos-gpu/bin/non-nixos-gpu-setup
```

Run the exact command printed in the current activation output:

```bash
sudo /nix/store/HASH-non-nixos-gpu/bin/non-nixos-gpu-setup
```

Do not reuse the command from an older driver version because its Nix store path
points to the old GPU environment. The setup script installs
`/etc/tmpfiles.d/non-nixos-gpu.conf` and creates `/run/opengl-driver`.

### 4. Verify the GPU environment

```bash
readlink -f /run/opengl-driver
ls /run/opengl-driver/share/glvnd/egl_vendor.d/
```

Re-running Home Manager should no longer print the GPU setup warning.

## Shared Agent Instructions and Skills

Keep global agent instructions in `agents/shared-instructions.md` as the single source of truth. Home Manager publishes it to:

- `~/.claude/CLAUDE.md` for Claude Code.
- `~/.codex/AGENTS.md` for Codex.

Keep reusable skills under `agents/skills/<skill-name>` as the single source of truth. Home Manager publishes that source to:

- `~/.agents/skills` for shared agent discovery.
- `~/.claude/skills` for Claude Code.
- `~/.codex/skills/<skill-name>` for Codex, one skill at a time so Codex's managed `~/.codex/skills/.system` directory remains intact.

After adding or updating a skill, apply the links with:

```bash
nix run home-manager -- switch --flake ~/dotfiles
```

## Adding a New Program

1. Create `programs/<name>.nix` with `programs.<name>` or `home.packages` + `xdg.configFile`.
2. Add the import in `programs/default.nix`.
3. Run `nix run home-manager -- switch --flake ~/dotfiles`.
