-- batto configuration
-- Edit this file to customize batto.

batto.setup({
  window = {
    width = 600,
    list_height = 300,
    icon_size = 48,
  },
  keys = {
    accept = "enter",
    close = "escape",
    up = "ctrl+k",
    down = "ctrl+j",
    tab_complete = "tab",
  },
})

-- Plugins:
batto.use("discord")
batto.use("web-search")
