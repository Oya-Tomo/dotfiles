return {
    -- lsp
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },
    -- completion
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    virtual_text = {
                        prefix = "!",
                        format = function (diagnostic)
                            return string.format("line:%s,col:%s", diagnostic.lnum + 1, diagnostic.col)
                        end,
                    },
                    signs = true,
                    update_in_insert = true,
                    underline = true,
                }
            )
        end,
    },
    "williamboman/mason-lspconfig.nvim",
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            require("cmp").setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = '...',
                        before = function(entry, vim_item)
                            return vim_item
                        end
                    })
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "cmdline" },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Up>"] = cmp.mapping.select_prev_item(),
                    ["<Down>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ['<C-l>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                }),
                experimental = {
                    ghost_text = true,
                },
            })
        end,
    },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    -- coding support
    "windwp/nvim-autopairs",
}