-- common
vim.g.mapleader = " "
vim.g.solarized_termcolors=256

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.background = "dark"

require("packer").startup(function(use)
    -- plugin manager
    use 'wbthomason/packer.nvim'
    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    -- completion
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    -- snippets
    use "hrsh7th/cmp-vsnip"
    use "hrsh7th/vim-vsnip"
    -- coloring
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    -- brackets completion
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end,
    }
    -- file finder
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    -- status line customize
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    -- themes
    use 'martinsione/darkplus.nvim'
    use 'folke/tokyonight.nvim'
    use "altercation/vim-colors-solarized"
end)

-- set themes
-- vim.cmd[[colorscheme tokyonight]]
vim.cmd [[colorscheme solarized]]

require("keymap")
