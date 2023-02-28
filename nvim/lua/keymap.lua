vim.keymap.set("n", "<leader>fmt", function()
    vim.lsp.buf.format({ async = false })
end, {})

vim.keymap.set("n", "<leader>di", function()
    vim.diagnostic.config({ virtual_text = true })
end, {})
