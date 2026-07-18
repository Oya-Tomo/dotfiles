# Nix Configuration

Home Manager configuration using Nix flakes. Manages packages, program settings, and dotfile symlinks.

## Structure

```
nix/
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
            ├── wezterm.nix  # WezTerm terminal package + config
            └── zsh.nix      # Zsh shell config (history, aliases, init-extra.zsh)
```

## GPU Support (non-NixOS)

On non-NixOS systems with NVIDIA hybrid graphics, GPU drivers are configured via `targets.genericLinux.gpu` in `default.nix`. See [Running WezTerm on non-NixOS](../docs/run-wezterm-on-non-nixos.md) for details.

## Shared Agent Instructions and Skills

Keep global agent instructions in `agents/.rules` as the single source of truth. Home Manager publishes it to:

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

## Required System-wide Numtide Cache

> [!IMPORTANT]
> This configuration installs Claude Code and Codex from `numtide/llm-agents.nix` and assumes the Numtide binary cache is configured system-wide. This is a required prerequisite, not an optional optimization. Configure it before evaluating, building, or applying this flake; otherwise Nix may build Codex locally.

On a multi-user Nix installation, add the following settings to `/etc/nix/nix.conf` as root:

```ini
extra-substituters = https://cache.numtide.com
extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
```

Restart `nix-daemon` (or reboot) after changing the system configuration. Then verify that both entries are effective:

```bash
nix config show | rg '^substituters = .*https://cache.numtide.com'
nix config show | rg '^trusted-public-keys = .*niks3.numtide.com-1:'
```

Do not work around this requirement by adding the regular user to `trusted-users`. The flake intentionally relies on the system configuration instead of granting the user daemon-level trust.

## Adding a New Program

1. Create `programs/<name>.nix` with `programs.<name>` or `home.packages` + `xdg.configFile`.
2. Add the import in `programs/default.nix`.
3. Run `nix run home-manager -- switch --flake ~/dotfiles`.
