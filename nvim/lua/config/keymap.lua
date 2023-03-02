vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>fmt", function()
    vim.lsp.buf.format({ async = false })
end, {})

vim.keymap.set("n", "<leader>od", function()
    vim.diagnostic.open_float()
end, {})

vim.keymap.set("i", "<C-s>", function ()
    vim.cmd(":w")
end)
