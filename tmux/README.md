# tmux Configuration

A tmux configuration with a `Ctrl+t` prefix, Kanagawa Wave colors, and keybindings that mirror the WezTerm and Ghostty pane/tab shortcuts.

## Features

- **Prefix**: `Ctrl+t`. `Ctrl+b` is left untouched because both terminal emulators bind it to "previous pane". `Ctrl+t` `Ctrl+t` sends a literal prefix to a nested tmux.
- **Colorscheme**: [Kanagawa Wave](https://github.com/rebelot/kanagawa.nvim) status line, borders, and copy-mode highlight, matching the terminal themes.
- **Neovim friendly**: truecolor and undercurl overrides, `focus-events on`, and a 10 ms escape time.
- **Copy mode**: vi keys, with selections piped to the system clipboard through `xclip`.
- **Windows and panes**: 1-based numbering with gapless renumbering, mouse support, and a 100,000 line scrollback.

## Keybindings

All bindings below are pressed after the `Ctrl+t` prefix. Bindings marked *repeatable* can be repeated without re-pressing the prefix.

### Pane Operations
| Keybinding | Action |
| :--- | :--- |
| `h` | Split vertical (left/right) |
| `v` | Split horizontal (top/bottom) |
| `q` | Close pane (with confirmation) |
| `z` | Toggle pane zoom |
| `Space` | Show pane numbers |
| `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l` | Move to the left/lower/upper/right pane (repeatable) |
| `H` / `J` / `K` / `L` | Resize pane left/down/up/right by 5 cells (repeatable) |

### Window Operations
| Keybinding | Action |
| :--- | :--- |
| `t` | New window (current directory) |
| `Q` | Close window (with confirmation) |
| `b` | Previous window (repeatable) |
| `n` | Next window (repeatable) |
| `B` | Move window left (repeatable) |
| `N` | Move window right (repeatable) |

### Session Operations
| Keybinding | Action |
| :--- | :--- |
| `s` | Choose a session or window from a tree |
| `d` | Detach the client |
| `r` | Reload `tmux.conf` |

### Copy Mode
| Keybinding | Action |
| :--- | :--- |
| `[` | Enter copy mode |
| `v` | Begin selection |
| `Ctrl+v` | Toggle rectangle selection |
| `y` | Copy the selection to the clipboard and exit |
| Mouse drag | Copy the selection to the clipboard |
| `p` | Paste the most recent buffer |

## Notes

- `Ctrl+t` replaces the zsh `transpose-chars` binding inside tmux sessions.
- Clipboard copying requires `xclip`, which is installed by [`nix/modules/home/packages.nix`](../nix/modules/home/packages.nix).

## Installation

Managed by Home Manager through [`nix/modules/home/programs/tmux.nix`](../nix/modules/home/programs/tmux.nix), which installs the `tmux` package and links this directory to `~/.config/tmux`:

```bash
nix run home-manager -- switch --flake ~/dotfiles
```

To use this configuration without Nix, install tmux with the host package manager and clone this directory into `~/.config/tmux`.
