return {
  -- Mason: LSP server manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = { "lua-language-server" },
    },
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

  -- LSP configuration
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
            map("n", "<leader>lgd", vim.lsp.buf.definition,
              { silent = true, buffer = buf, desc = "Go to Definition" })
          end
          if client:supports_method("textDocument/typeDefinition") then
            map("n", "<leader>lgtd", vim.lsp.buf.type_definition,
              { silent = true, buffer = buf, desc = "Go to Type Definition" })
          end
          if client:supports_method("textDocument/references") then
            map("n", "<leader>lgr",
              function() vim.lsp.buf.references({ focusable = false, includeDeclaration = true }) end,
              { silent = true, buffer = buf, desc = "Find References" })
          end
          if client:supports_method("textDocument/hover") then
            map("n", "<leader>lhh", vim.lsp.buf.hover,
              { silent = true, buffer = buf, desc = "Hover Documentation" })
          end
          if client:supports_method("textDocument/rename") then
            map("n", "<leader>lrn", vim.lsp.buf.rename,
              { silent = true, buffer = buf, desc = "Rename Symbol" })
          end
          if client:supports_method("textDocument/codeAction") then
            map("n", "<leader>lca", vim.lsp.buf.code_action,
              { silent = true, buffer = buf, desc = "Code Action" })
          end
          if client:supports_method("textDocument/implementation") then
            map("n", "<leader>lgi", vim.lsp.buf.implementation,
              { silent = true, buffer = buf, desc = "Go to Implementation" })
          end

          map("n", "<leader>lds", vim.diagnostic.open_float,
            { silent = true, buffer = buf, desc = "Show Diagnostic" })
          map("n", "<leader>ldn", function() vim.diagnostic.jump({ count = 1 }) end,
            { silent = true, buffer = buf, desc = "Next Diagnostic" })
          map("n", "<leader>ldp",
            function() vim.diagnostic.jump({ count = -1 }) end,
            { silent = true, buffer = buf, desc = "Prev Diagnostic" })
        end,
      })
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
      format_on_save = {
        timeout_ms = 5000,
        lsp_fallback = true,
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.keymap.set({ "n", "v" }, "<leader>lf", function()
        require("conform").format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format File or Range (in visual mode)" })
    end,
  },

  -- Lspkind icons
  {
    "onsails/lspkind.nvim",
    lazy = true,
    opts = {
      preset = "codicons",
      symbol_map = { Snippet = "" },
    },
  },
}
