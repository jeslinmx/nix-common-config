vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable autoformat-on-save" })
vim.api.nvim_create_user_command("FormatEnable", function(args)
  if args.bang then
    vim.b.disable_autoformat = false
  else
    vim.g.disable_autoformat = false
  end
end, { desc = "Enable autoformat-on-save" })

vim.api.nvim_create_user_command("PartialFormatDisable", function(args)
  if args.bang then
    vim.b.disable_partial_autoformat = true
  else
    vim.g.disable_partial_autoformat = true
  end
end, { desc = "Format entire file on save" })
vim.api.nvim_create_user_command("PartialFormatEnable", function(args)
  if args.bang then
    vim.b.disable_partial_autoformat = false
  else
    vim.g.disable_partial_autoformat = false
  end
end, { desc = "Format only modified hunks on save" })

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

    format_on_save = function(bufnr)
      local conform_opts = { timeout_ms = 500, lsp_format = "fallback" }

      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      local range_ignore_filetypes = { "lua" }
      if
        vim.tbl_contains(range_ignore_filetypes, vim.bo.filetype)
        or vim.g.disable_partial_autoformat
        or vim.b[bufnr].disable_partial_autoformat
      then
        return conform_opts
      end

      local hunks = (require("mini.diff").get_buf_data() or {}).hunks
      if not hunks then
        vim.notify("No hunks in this buffer to format.", vim.log.levels.INFO, { title = "Conform" })
        return
      end

      local format = require("conform").format
      local function format_range()
        local hunk = table.remove(hunks)
        if hunk == nil or hunk.type == "delete" then
          return
        end

        local start = hunk.buf_start
        local last = start + hunk.buf_count - 1
        -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
        local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 1, last, true)[1]
        local range = { start = { start, 0 }, ["end"] = { last, last_hunk_line:len() } }
        format({ range = range, timeout = 500, lsp_format = "fallback" }, function()
          vim.schedule(format_range)
        end)
      end
      format_range()
    end,
  },

  event = "BufWritePre",
}
