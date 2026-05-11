# Neovim Configuration

This is a custom Neovim configuration built with `lazy.nvim` as the plugin manager. It provides a modern, feature-rich development environment with LSP support, fuzzy finding, and a polished UI.

## 🚀 Features

- **Plugin Management**: Powered by [lazy.nvim](https://github.com/folke/lazy.nvim).
- **Colorscheme**: [Kanagawa](https://github.com/rebelot/kanagawa.nvim) for a beautiful, calm aesthetic.
- **LSP (Language Server Protocol)**: Full support via [mason.nvim](https://github.com/williamboman/mason.nvim) and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).
- **Autocompletion**: Fast and intuitive completion using [blink.cmp](https://github.com/saghen/blink.cmp).
- **Fuzzy Finding**: Powerful searching with [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim).
- **UI Enhancements**:
  - [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) for VS Code-like tabs.
  - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) for a sleek status line.
  - [which-key.nvim](https://github.com/folke/which-key.nvim) for helpful keybinding hints.
  - [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for file type icons.
  - [minimap.vim](https://github.com/sharkdp/minimap.vim) for a code minimap.

## ⌨️ Keybindings

The `<leader>` key is set to `Space`.

### 📑 Tab Navigation
| Keybinding | Action |
| :--- | :--- |
| `<leader>tc` | Create new tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |
| `<leader>td` | Delete current tab |

### 🪟 Window Management
| Keybinding | Action |
| :--- | :--- |
| `<leader>wj` | Move window down |
| `<leader>wk` | Move window up |
| `<leader>wl` | Move window right |
| `<leader>wh` | Move window left |
| `<leader>wsv` | Vertical split |
| `<leader>wsh` | Horizontal split |

### 🔍 Telescope (Fuzzy Finding)
| Keybinding | Action |
| :--- | :--- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep current word |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>gs` | Document symbols |

### 🛠️ LSP (Language Server Protocol)
| Keybinding | Action |
| :--- | :--- |
| `<leader>gd` | Go to definition |
| `<leader>gtd` | Go to type definition |
| `<leader>gr` | Find references |
| `<leader>hh` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>gi` | Go to implementation |
| `<leader>cf` | Format document |
| `<leader>gl` | Show diagnostic |

## 🛠️ Installation

1. Ensure you have [Neovim](https://neovim.io/) installed.
2. Clone this configuration into your `~/.config/nvim` directory.
3. Open Neovim, and `lazy.nvim` will automatically install the required plugins.
