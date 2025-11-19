return {
  {
    "nvzone/showkeys",

    opts = {
      position = "top-right",
      timeout = 1,
      maxkeys = 5,
      show_count = true,
      excluded_modes = { "i", "c" },
      winopts = { border = "none" },
      keyformat = {
        ["<C>"] = "^",
        ["<M>"] = "⎇",
        ["<BS>"] = "⌫",
        ["<Esc>"] = "󱊷",
        ["<CR>"] = "↵",
        ["<Tab>"] = "󰞔",
        ["<Space>"] = "␣",
        ["<Up>"] = "↑",
        ["<Down>"] = "↓",
        ["<Left>"] = "←",
        ["<Right>"] = "→",
        ["<PageUp>"] = "󰞕",
        ["<PageDown>"] = "󰞒",
      },
    },

    cmd = "ShowkeysToggle",
    event = "UIEnter",
  },
  { "nvzone/minty", dependencies = "nvzone/volt", cmd = { "Shades", "Huefy" } },
  { "nvzone/timerly", dependencies = "nvzone/volt", cmd = "TimerlyToggle" },
}
