# Wezterm Configuration

A Wezterm terminal configuration with a Kanagawa colorscheme, custom keybindings, and IDE layout support.

## Features

- **Colorscheme**: [Kanagawa (Gogh)](https://github.com/goatslacker/alt-terminal-themes) for a calm aesthetic.
- **Font**: Hack Nerd Font Mono with fallback.
- **Window chrome**: Borderless window with a compact, draggable tab bar.
- **Leader Key**: `Ctrl+l` with 1-second timeout (reserved for future use).

## Keybindings

### Tab Operations
| Keybinding | Action |
| :--- | :--- |
| `Alt+t` | New tab (current directory) |
| `Alt+q` | Close tab (with confirmation) |
| `Alt+b` | Previous tab |
| `Alt+n` | Next tab |
| `Alt+Shift+b` | Move tab left |
| `Alt+Shift+n` | Move tab right |

### Pane Operations
| Keybinding | Action |
| :--- | :--- |
| `Ctrl+h` | Split vertical (left/right) |
| `Ctrl+v` | Split horizontal (top/bottom) |
| `Ctrl+q` | Close pane (with confirmation) |
| `Ctrl+n` | Next pane |
| `Ctrl+b` | Previous pane |
| `Ctrl+Shift+h` | Resize pane left |
| `Ctrl+Shift+l` | Resize pane right |
| `Ctrl+Shift+k` | Resize pane up |
| `Ctrl+Shift+j` | Resize pane down |

### Clipboard
| Keybinding | Action |
| :--- | :--- |
| `Ctrl+Shift+c` | Copy to clipboard |
| `Ctrl+Shift+v` | Paste from clipboard |

### Layout
| Keybinding | Action |
| :--- | :--- |
| `Ctrl+Alt+i` | Run `alias/ide.sh` on the focused pane — default IDE layout (one pane above three) |

### Alias Scripts
The `alias/` directory contains convenience scripts:

- **`ide.sh`** (`ide [TOP BOTTOM]`): Arranges the current pane into two rows.
  - `ide` — one top pane (70% height) above three equal bottom panes.
  - `ide 2 3` — two panes on top, three below; both rows get the same height and each row is divided into equal columns.

  Focus ends on the top-left pane. The `ide` shell command and `Ctrl+Alt+i` both run this script; only the shell command accepts pane counts.

## Installation

1. Ensure you have [Wezterm](https://wezfurlong.org/wezterm/) installed.
2. Clone this configuration into your `~/.config/wezterm` directory.
3. Launch Wezterm — the config loads automatically.
