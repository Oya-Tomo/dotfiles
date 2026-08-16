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

### Events
| Keybinding | Action |
| :--- | :--- |
| `Ctrl+Alt+i` | Emit `ide` event — create IDE layout (split into 4 panes) |

### Alias Scripts
The `alias/` directory contains convenience scripts:

- **`ide.sh`**: Creates a 4-pane IDE layout — top pane (70% height), left bottom pane (30% width), right split of that (50%), and remaining area. Panes clear on creation.

## Installation

1. Ensure you have [Wezterm](https://wezfurlong.org/wezterm/) installed.
2. Clone this configuration into your `~/.config/wezterm` directory.
3. Launch Wezterm — the config loads automatically.
