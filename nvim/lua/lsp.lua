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


