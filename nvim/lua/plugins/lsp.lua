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
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require('mason').setup()
            require('mason-lspconfig').setup()

            require('mason-lspconfig').setup_handlers({
                function(server)
                    require('lspconfig')[server].setup({
                        capabilities = capabilities,
                    })
                end
            })
        end,
    },
}
