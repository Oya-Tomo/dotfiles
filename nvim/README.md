# Neovim Configuration

This is a custom Neovim configuration built with `lazy.nvim` as the plugin manager. It provides a modern, feature-rich development environment with LSP support, fuzzy finding, and a polished UI.

## Features

- **Plugin Management**: [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.
- **Colorscheme**: [Kanagawa](https://github.com/rebelot/kanagawa.nvim) for a beautiful, calm aesthetic.
- **LSP (Language Server Protocol)**: [mason.nvim](https://github.com/williamboman/mason.nvim), [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim), and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for LSP support.
- **Autocompletion**: [blink.cmp](https://github.com/saghen/blink.cmp) for fast completion with [LuaSnip](https://github.com/L3MON4D3/LuaSnip) for snippet support.
- **Fuzzy Finding**: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for powerful searching.
- **Code Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) for smart formatting (LSP fallback + per-language formatters).
- **Git Integration**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) for inline blame and hunk management.
- **UI Enhancements**:
  - [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) for VS Code-like tabs.
  - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) for a sleek status line.
  - [which-key.nvim](https://github.com/folke/which-key.nvim) for keybinding hints.
  - [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for file type icons.
  - [lspkind.nvim](https://github.com/onsails/lspkind.nvim) for LSP completion icons.
  - [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) for smooth scrolling.
  - [minimap.vim](https://github.com/wfxr/minimap.vim) for a code minimap.
  - [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) for indent guides.
- **Snippets**: [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) for pre-built snippet collections.

## Keybindings

The `<leader>` key is set to `Space`.

### Tab Navigation
| Keybinding | Action |
| :--- | :--- |
| `<leader>tc` | Create new tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |
| `<leader>td` | Delete current tab |

### Window Management
| Keybinding | Action |
| :--- | :--- |
| `<leader>wj` | Move window down |
| `<leader>wk` | Move window up |
| `<leader>wl` | Move window right |
| `<leader>wh` | Move window left |
| `<leader>wsv` | Vertical split |
| `<leader>wsh` | Horizontal split |

### Telescope (Fuzzy Finding)
| Keybinding | Action |
| :--- | :--- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep current word |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>gs` | Goto symbol |

### LSP (Language Server Protocol)
| Keybinding | Action |
| :--- | :--- |
| `<leader>lgd` | Go to definition |
| `<leader>lgtd` | Go to type definition |
| `<leader>lgr` | Find references |
| `<leader>lhh` | Hover documentation |
| `<leader>lrn` | Rename symbol |
| `<leader>lca` | Code action |
| `<leader>lgi` | Go to implementation |
| `<leader>lf` | Format document |

### Diagnostics
| Keybinding | Action |
| :--- | :--- |
| `<leader>lds` | Show diagnostic |
| `<leader>ldn` | Next diagnostic |
| `<leader>ldp` | Previous diagnostic |

### Git (Gitsigns)
| Keybinding | Action |
| :--- | :--- |
| `<leader>ghn` | Next hunk |
| `<leader>ghp` | Previous hunk |
| `<leader>ghb` | Git blame |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghv` | Preview hunk |

### Scrolling
| Keybinding | Action |
| :--- | :--- |
| `<C-y>` | Scroll up (cursor stays) |
| `<C-e>` | Scroll down (cursor stays) |
| `<leader>cu` | Scroll to top |
| `<leader>cc` | Center cursor |
| `<leader>cb` | Scroll to bottom |

## Installation

1. Ensure you have [Neovim](https://neovim.io/) installed.
2. Clone this configuration into your `~/.config/nvim` directory.
3. Open Neovim, and `lazy.nvim` will automatically install the required plugins.
