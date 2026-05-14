# Dotfiles

My personal configuration files for a productive development environment.

## Included Software

| Component | Configuration | Description |
| :--- | :--- | :--- |
| **Neovim** | [`nvim/`](nvim/README.md) | LSP-driven editor with blink.cmp, Telescope, gitsigns, conform.nvim and more |
| **WezTerm** | [`wezterm/`](wezterm/README.md) | Terminal with Kanagawa colorscheme, custom pane/tab shortcuts, and IDE layout support |
| **Zsh** | `.zshrc` | Shell configuration |
| **Starship** | `starship.toml` | Shell prompt configuration |
| **Mise** | `mise/` | Tool version manager configuration |

Detailed information for each component can be found in its respective directory.

## Environment Variables

The following environment variables are required for some aliases to function correctly:

### Tailscale
- `TS_EXIT_NODE`: Specifies the exit node for the `tsen-on` command.

### Claude Local Model
- `CLAUDE_LOCAL_HOST`: Host address for the local Claude-compatible API.
- `CLAUDE_LOCAL_PORT`: Port number for the local Claude-compatible API.
- `CLAUDE_LOCAL_MODEL`: Name of the local model to be used with the `claude-gemma4` command.

## Installation

To apply these configurations to your system, run the `update.sh` script:

```bash
./update.sh
```

> [!WARNING]
> The `update.sh` script will overwrite your existing `~/.config/nvim`, `~/.config/wezterm`, and `~/.zshrc`. Please ensure you have backups of your current configurations before running it.
