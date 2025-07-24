return {
    -- lsp
    {
        "mason-org/mason.nvim",
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
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        config = function(_, opts)
            require("mason-lspconfig").setup({
                automatic_enable = true
            })
        end,
    }
}
