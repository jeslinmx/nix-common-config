return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = { implementation = "prefer_rust_with_warning" },
    keymap = {
      preset = "none",
      ["<C-l>"] = { "show_documentation", "hide_documentation", "show_and_insert", "fallback" },
      ["<cr>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-u>"] = { "scroll_signature_up", "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_signature_down", "scroll_documentation_down", "fallback" },
    },
    completion = {
      keyword = { range = "full" },
      list = { selection = { preselect = false, auto_insert = true } },
      documentation = { auto_show = true, auto_show_delay_ms = 0 },
      menu = { draw = { treesitter = { "lsp" } } },
    },

    cmdline = {
      keymap = { preset = "inherit" },
      completion = {
        menu = { auto_show = true },
        list = { selection = { preselect = false, auto_insert = true } },
        ghost_text = { enabled = false },
      },
    },
  },
  opts_extend = { "sources.default" },
}
