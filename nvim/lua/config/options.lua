-- Basic options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.clipboard = "unnamedplus"

-- 24bit color support
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Rendering
vim.opt.lazyredraw = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
