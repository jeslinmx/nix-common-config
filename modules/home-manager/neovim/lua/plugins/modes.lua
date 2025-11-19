return {
  "mvllow/modes.nvim",

  opts = {
    colors = {
      insert = _G.palette.base0D,
      visual = _G.palette.base0B,
      select = _G.palette.base0B,
      copy = _G.palette.base0A,
      delete = _G.palette.base08,
      change = _G.palette.base0E,
      replace = _G.palette.base0E,
      format = _G.palette.base09,
    },

    -- Set opacity for cursorline and number background
    line_opacity = 0.15,

    -- Enable cursor highlights
    set_cursor = true,

    -- Enable cursorline initially, and disable cursorline for inactive windows
    -- or ignored filetypes
    set_cursorline = true,

    -- Enable line number highlights to match cursorline
    set_number = true,

    -- Enable sign column highlights to match cursorline
    set_signcolumn = true,

    -- Disable modes highlights for specified filetypes
    -- or enable with prefix "!" if otherwise disabled (please PR common patterns)
    -- Can also be a function fun():boolean that disables modes highlights when true
    ignore = { "NvimTree", "TelescopePrompt", "!minifiles" },
  },

  event = "VimEnter",
}
