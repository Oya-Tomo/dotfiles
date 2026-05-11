-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab navigation
vim.keymap.set("n", "<leader>tc", vim.cmd.tabnew,  { desc = "Tab Create" })
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
vim.keymap.set("n", "<leader>wsh", vim.cmd.split,   { desc = "Horizontal Split" })

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Colorscheme
    { "rebelot/kanagawa.nvim" },

    -- Keybind helper
    { "folke/which-key.nvim", event = "VeryLazy" },

    -- Icons
    { "nvim-tree/nvim-web-devicons" },

    -- LSP
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      config = function()
        require("mason").setup({
          ensure_installed = { "lua-language-server" },
        })
      end,
    },
   -- Bridge: auto-enable mason-installed servers
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = "mason.nvim",
      config = function()
        require("mason-lspconfig").setup({})
        vim.lsp.enable(require("mason-lspconfig").get_installed_servers())
      end,
    },

    -- Lua LSP server-specific settings (after/lsp/ equivalent)
    {
      "neovim/nvim-lspconfig",
      dependencies = { "mason.nvim", "mason-lspconfig.nvim" },
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        -- Global: blink.cmp capabilities for all servers
        vim.lsp.config("*", {
          capabilities = require("blink.cmp").get_lsp_capabilities({}),
        })

        -- Lua server: add Neovim runtime types
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              workspace = { library = { vim.env.VIMRUNTIME .. "/lua" } },
            },
          },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("lsp_keymaps", {}),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end

            local buf = args.buf
            local map = vim.keymap.set

            if client:supports_method("textDocument/definition") then
              map("n", "<leader>gd", vim.lsp.buf.definition, { silent = true, buffer = buf, desc = "Go to Definition" })
            end
            if client:supports_method("textDocument/typeDefinition") then
              map("n", "<leader>gtd", vim.lsp.buf.type_definition, { silent = true, buffer = buf, desc = "Go to Type Definition" })
            end
            if client:supports_method("textDocument/references") then
              map("n", "<leader>gr", function() vim.lsp.buf.references({ focusable = false, includeDeclaration = true }) end, { silent = true, buffer = buf, desc = "Find References" })
            end
            if client:supports_method("textDocument/hover") then
              map("n", "<leader>hh", vim.lsp.buf.hover, { silent = true, buffer = buf, desc = "Hover Documentation" })
            end
            if client:supports_method("textDocument/rename") then
              map("n", "<leader>rn", vim.lsp.buf.rename, { silent = true, buffer = buf, desc = "Rename Symbol" })
            end
            if client:supports_method("textDocument/codeAction") then
              map("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true, buffer = buf, desc = "Code Action" })
            end
            if client:supports_method("textDocument/implementation") then
              map("n", "<leader>gi", vim.lsp.buf.implementation, { silent = true, buffer = buf, desc = "Go to Implementation" })
            end
            if client:supports_method("textDocument/formatting") then
              map("n", "<leader>cf", vim.lsp.buf.format, { silent = true, buffer = buf, desc = "Format Document" })
            end

            map("n", "<leader>lds", vim.diagnostic.open_float, { silent = true, buffer = buf, desc = "Show Diagnostic" })
            map("n", "<leader>ldn", function() vim.diagnostic.jump({ count = 1 }) end, { silent = true, buffer = buf, desc = "Next Diagnostic" })
            map("n", "<leader>ldp", function() vim.diagnostic.jump({ count = -1 }) end, { silent = true, buffer = buf, desc = "Prev Diagnostic" })
          end,
        })
      end,
    },

    -- lspkind icons
    {
      "onsails/lspkind.nvim",
      lazy = true,
      opts = {
        preset = "codicons",
        symbol_map = { Snippet = "" },
      },
    },

   -- Fuzzy finder (Telescope)
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
        vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep Current Word" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
        vim.keymap.set("n", "<leader>gs", builtin.lsp_document_symbols, { desc = "Goto Symbol" })
      end,
    },

    -- Autocompletion (blink.cmp)
    {
      "saghen/blink.cmp",
      branch = "v1",
      dependencies = {
        "rafamadriz/friendly-snippets",
        "L3MON4D3/LuaSnip",
        "onsails/lspkind.nvim",
      },
      opts = {
        -- Keymaps
        keymap = { preset = "default" },

        -- Completion menu with icons
        completion = {
          menu = {
            draw = {
              components = {
                kind_icon = {
                  text = function(ctx)
                    return require("lspkind").symbol_map[ctx.kind] or ""
                  end,
                },
              },
            },
          },
          documentation = { auto_show = true },
        },

        -- Sources
        sources = {
          default = { "lsp", "snippets", "path", "buffer" },
        },
        cmdline = {
          completion = {
            menu = { auto_show = true },
          },
        },

        -- Snippet engine
        snippets = { preset = "luasnip" },

        -- Fuzzy matching
        fuzzy = { implementation = "prefer_rust_with_warning" },

        -- Appearance
        appearance = { nerd_font_variant = "mono" },
      },
    },

    -- Buffer tab line (VS Code-like tabs at top)
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("bufferline").setup({
          options = {
            mode = "tabs",
            themable = true,
            separator_style = "slant",
          },
        })
      end,
    },

    -- Status line
    {
      "nvim-lualine/lualine.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("lualine").setup({
          options = {
            theme = "kanagawa",
          },
        })
      end,
    },

    -- Git signs
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
        -- Navigation
        vim.keymap.set('n', '<leader>ghn', function() require('gitsigns').next_hunk() end, { desc = "Next Hunk" })
        vim.keymap.set('n', '<leader>ghp', function() require('gitsigns').prev_hunk() end, { desc = "Prev Hunk" })
        -- Actions
        vim.keymap.set('n', '<leader>ghb', function() require('gitsigns').blame_line({ hl = true }) end, { desc = "Git Blame" })
        vim.keymap.set('n', '<leader>ghs', function() require('gitsigns').stage_hunk() end, { desc = "Stage Hunk" })
        vim.keymap.set('n', '<leader>ghr', function() require('gitsigns').reset_hunk() end, { desc = "Reset Hunk" })
        vim.keymap.set('n', '<leader>ghv', function() require('gitsigns').preview_hunk() end, { desc = "Preview Hunk" })
      end,
    },

    -- Minimap
    { "wfxr/minimap.vim" },
  },
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true },
})

vim.cmd.colorscheme("kanagawa")

