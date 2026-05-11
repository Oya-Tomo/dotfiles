# Dotfiles

My personal configuration files for a productive development environment.

## Included Software

| Component | Configuration | Description |
| :--- | :--- | :--- |
| **Neovim** | `nvim/` | Text editor configuration |
| **WezTerm** | `wezterm/` | Terminal emulator configuration |
| **Zsh** | `.zshrc` | Shell configuration |
| **Starship** | `starship.toml` | Shell prompt configuration |
| **Mise** | `mise/` | Tool version manager configuration |

Detailed information for each component can be found in its respective directory.

## Installation

To apply these configurations to your system, run the `update.sh` script:

```bash
./update.sh
```

> [!WARNING]
> The `update.sh` script will overwrite your existing `~/.config/nvim`, `~/.config/wezterm`, and `~/.zshrc`. Please ensure you have backups of your current configurations before running it.
