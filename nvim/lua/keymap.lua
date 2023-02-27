vim.keymap.set("n", "<leader>fmt", function ()
	vim.lsp.buf.formatting_sync()
end, {})
