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

## Adding a New Program

1. Create `programs/<name>.nix` with `programs.<name>` or `home.packages` + `xdg.configFile`.
2. Add the import in `programs/default.nix`.
3. Run `nix run home-manager -- switch --flake ~/dotfiles`.
