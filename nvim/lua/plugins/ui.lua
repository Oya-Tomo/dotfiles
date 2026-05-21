return {
  -- Keybind helper
  { "folke/which-key.nvim", event = "VeryLazy" },

  -- Icons
  { "nvim-tree/nvim-web-devicons" },

  -- Buffer tab line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "tabs",
        themable = true,
        separator_style = "slant",
      },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        theme = "kanagawa",
      },
    },
  },

  -- Minimap
  { "wfxr/minimap.vim" },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
    },
  },
}
