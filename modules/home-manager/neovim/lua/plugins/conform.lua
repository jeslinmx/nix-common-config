return {
  "stevearc/conform.nvim",

  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "alejandra" },
      html = { "prettierd", "prettier" },
      vue = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },
      scss = { "prettierd", "prettier" },
      sass = { "prettierd", "prettier" },
      less = { "prettierd", "prettier" },
      javascript = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" },
      json = { "prettierd", "prettier" },
      json5 = { "prettierd", "prettier" },
      yaml = { "prettierd", "prettier" },
      graphql = { "prettierd", "prettier" },
    },

    default_format_opts = {
      timeout_ms = 500,
      lsp_fallback = "fallback",
    },
  },

  event = "BufWritePre",
}
