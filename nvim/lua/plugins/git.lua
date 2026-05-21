return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      -- Navigation
      vim.keymap.set('n', '<leader>ghn', function() require('gitsigns').next_hunk() end,
        { desc = "Next Hunk" })
      vim.keymap.set('n', '<leader>ghp', function() require('gitsigns').prev_hunk() end,
        { desc = "Prev Hunk" })
      -- Actions
      vim.keymap.set('n', '<leader>ghb',
        function() require('gitsigns').blame_line({ hl = true }) end,
        { desc = "Git Blame" })
      vim.keymap.set('n', '<leader>ghs', function() require('gitsigns').stage_hunk() end,
        { desc = "Stage Hunk" })
      vim.keymap.set('n', '<leader>ghr', function() require('gitsigns').reset_hunk() end,
        { desc = "Reset Hunk" })
      vim.keymap.set('n', '<leader>ghv', function() require('gitsigns').preview_hunk() end,
        { desc = "Preview Hunk" })
    end,
  },
}
