return {
  {
    "saghen/blink.cmp",
    branch = "v1",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind.nvim",
    },
    opts = {
      keymap = { preset = "default" },
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
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
      cmdline = {
        completion = {
          menu = { auto_show = true },
        },
      },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      appearance = { nerd_font_variant = "mono" },
    },
  },
}
