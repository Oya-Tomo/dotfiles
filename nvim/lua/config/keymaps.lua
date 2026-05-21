-- Tab navigation
vim.keymap.set("n", "<leader>tc", vim.cmd.tabnew, { desc = "Tab Create" })
vim.keymap.set("n", "<leader>tn", vim.cmd.tabnext, { desc = "Tab Next" })
vim.keymap.set("n", "<leader>tp", vim.cmd.tabprev, { desc = "Tab Prev" })
vim.keymap.set("n", "<leader>td", vim.cmd.tabclose, { desc = "Tab Delete" })

-- Window navigation
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Window Down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Window Up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Window Right" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Window Left" })

-- Splits
vim.keymap.set("n", "<leader>wsv", vim.cmd.vsplit, { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>wsh", vim.cmd.split, { desc = "Horizontal Split" })
