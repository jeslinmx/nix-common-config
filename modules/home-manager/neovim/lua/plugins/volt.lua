return {
  {
    "nvzone/showkeys",
    opts = {
      position = "top-right",
      maxkeys = 5,
      show_count = true,
      excluded_modes = { "i", "c" },
      winopts = { border = "rounded", relative = "editor" },
      keyformat = {
        ["<C>"] = "^",
        ["<M>"] = "⎇",
        ["<BS>"] = "⌫",
        ["<CR>"] = "↵",
        ["<Space>"] = "␣",
        ["<Up>"] = "↑",
        ["<Down>"] = "↓",
        ["<Left>"] = "←",
        ["<Right>"] = "→",
        ["<PageUp>"] = "pg↑",
        ["<PageDown>"] = "pg↓",
      },
    },
    cmd = "ShowkeysToggle",
    event = "UIEnter",
  },
  { "nvzone/minty", dependencies = "nvzone/volt", cmd = { "Shades", "Huefy" } },
  { "nvzone/timerly", dependencies = "nvzone/volt", cmd = "TimerlyToggle" },
}
