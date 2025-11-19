return {
  "ms-jpq/coq_nvim",
  branch = "coq",
  dependencies = {
    { "ms-jpq/coq.artifacts", branch = "artifacts" },
    { "ms-jpq/coq.thirdparty", branch = "3p" },
  },

  init = function()
    vim.g.coq_settings = {
      auto_start = true,
      completion = {
        skip_after = { "(", ")", "{", "}", "[", "]", ",", ";" },
      },
      display = {
        icons = {
          mode = "short",
          mappings = {
            Class = "",
            Color = "",
            Constant = "",
            Constructor = "󱁤",
            Enum = "",
            EnumMember = "",
            Event = "",
            Field = "󰘎",
            File = "",
            Folder = "",
            Function = "󰊕",
            Interface = "",
            Keyword = "",
            Method = "",
            Module = "",
            Operator = "",
            Property = "",
            Reference = "",
            Snippet = "󰩫",
            Struct = "",
            Text = "",
            TypeParameter = "",
            Unit = "",
            Value = "",
            Variable = "󰫧",
          },
        },
        pum = {
          fast_close = true,
          kind_context = { "", "" },
          source_context = { "", "" },
          x_max_len = 66,
        },
        preview = {
          border = {
            { "", "NormalFloat" },
            { "", "NormalFloat" },
            { "", "NormalFloat" },
            { " ", "NormalFloat" },
            { "", "NormalFloat" },
            { "", "NormalFloat" },
            { "", "NormalFloat" },
            { " ", "NormalFloat" },
          },
          x_max_len = 66,
        },
      },
    }
    require "coq_3p" {
      { src = "repl", sh = "bash" },
      { src = "nvimlua", short_name = "nLUA", conf_only = false },
      { src = "bc", short_name = "MATH", precision = 6 },
      { src = "codeium", short_name = "COD" },
      -- { src = "dap" },
    }
  end,
}
