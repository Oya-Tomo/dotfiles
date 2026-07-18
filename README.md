# Dotfiles

My personal configuration files for a productive development environment.

## Included Software

| Component | Configuration | Description |
| :--- | :--- | :--- |
| **Neovim** | [`nvim/`](nvim/README.md) | LSP-driven editor with blink.cmp, Telescope, gitsigns, conform.nvim and more |
| **WezTerm** | [`wezterm/`](wezterm/README.md) | Terminal with Kanagawa colorscheme, custom pane/tab shortcuts, and IDE layout support |
| **Ghostty** | [`ghostty/`](ghostty/README.md) | Terminal with WezTerm-compatible keybindings, Kanagawa theme, and Hack Nerd Font |
| **Zsh** | [`zsh/`](zsh/) | Shell configuration |
| **Starship** | [`starship.toml`](starship.toml) | Shell prompt configuration |
| **Lazygit** | [`lazygit/`](lazygit/) | Terminal UI for Git |
| **Mise** | [`mise/`](mise/) | Tool version manager configuration |
| **Claude Code** | [`claude/`](claude/) | Settings, statusline, Discord plugin config |
| **Agents** | [`agents/`](agents/) | Shared AI agent instructions and skills |
| **Nix** | [`nix/`](nix/README.md) | Home Manager configuration (packages, programs, GPU support) |

Detailed information for each component can be found in its respective directory.

## Environment Variables

The following environment variables are required for some aliases to function correctly:

### Tailscale
- `TS_EXIT_NODE`: Specifies the exit node for the `tsen-on` command.

### Claude Local Model
- `CLAUDE_LOCAL_HOST`: Host address for the local Claude-compatible API.
- `CLAUDE_LOCAL_PORT`: Port number for the local Claude-compatible API.
- `CLAUDE_LOCAL_MODEL`: Name of the local model to be used with the `claude-local` command.

### Claude GLM
- `ZAI_TOKEN`: API token for the `claude-glm` command (GLM models via z.ai).

### Discord Plugin
- `DISCORD_BOT_TOKEN`: Bot token for the Claude Code Discord integration. Place in `~/.claude/channels/discord/.env` (see `claude/channels/discord/.env.example`).

## Secrets

Private environment variables are loaded from `~/.secrets` (not tracked by git). Create it manually:

```bash
export ZAI_TOKEN=your_token_here
export TS_EXIT_NODE=your_exit_node_here
export CLAUDE_LOCAL_HOST=127.0.0.1
export CLAUDE_LOCAL_PORT=8080
export CLAUDE_LOCAL_MODEL=model-name
```

## Installation

### Nix (recommended)

> [!IMPORTANT]
> This configuration assumes that the Numtide binary cache has already been configured system-wide. Complete the [required cache setup](nix/README.md#required-system-wide-numtide-cache) before applying the flake. Do not run Home Manager first: without the cache, Nix may build Codex locally.

Apply configuration with Home Manager:

```bash
nix run home-manager -- switch --flake ~/dotfiles
```
