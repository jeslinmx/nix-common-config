return {
  "folke/snacks.nvim",

  opts = {
    bigfile = {},
    dashboard = {
      sections = {
        { section = "keys", gap = 1, padding = 1 },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
          limit = 10,
          cwd = true,
        },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          enabled = function()
            return require("snacks").git.get_root() ~= nil
          end,
          key = "b",
          action = function()
            require("snacks").gitbrowse()
          end,
        },
        function()
          local in_git = require("snacks").git.get_root() ~= nil
          local cmds = {
            {
              icon = " ",
              title = "Git Status",
              cmd = "git status --short --branch --renames",
              height = 5,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 3,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 3,
            },
            {
              title = "Github Notifications",
              cmd = "gh notify -s -a -n" .. ((in_git and 5) or 24),
              action = function()
                vim.ui.open "https://github.com/notifications"
              end,
              key = "n",
              icon = " ",
              height = (in_git and 5) or 24,
              enabled = true,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
      preset = {
        keys = {
          { icon = " ", key = "e", desc = "Empty buffer", action = ":ene" },
          { icon = " ", key = "s", desc = "Restore session", section = "session" },
          {
            icon = "󰒲 ",
            key = "L",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          {
            icon = "󰐻 ",
            key = "M",
            desc = "MCP Hub",
            action = ":MCPHub",
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = "",
      },
    },
    explorer = { replace_netrw = true },
    picker = {
      sources = {
        git_log = { layout = "bottom" },
        git_log_line = { layout = "bottom" },
        git_log_file = { layout = "bottom" },
        git_branches = { layout = "dropdown" },
        git_files = { layout = "sidebar", finder = "explorer" },
        diagnostics = { layout = "ivy_split" },
        diagnostics_buffer = { layout = "ivy_split" },
        lsp_definitions = { layout = "dropdown" },
        lsp_declarations = { layout = "dropdown" },
        lsp_implementations = { layout = "dropdown" },
        lsp_references = { layout = "dropdown" },
        lsp_symbols = { layout = "dropdown" },
        lsp_type_definitions = { layout = "dropdown" },
        commands = { layout = "vscode" },
        keymaps = { layout = { preview = false } },
        undo = { layout = "dropdown" },
        explorer = {
          focus = "input",
          auto_close = true,
          win = { list = { keys = { ["<cr>"] = "confirm" } } },
          layout = { preview = "main" },
        },
      },
    },
    terminal = {},
    scroll = {},
    quickfile = {},
    toggle = {},
    indent = {
      indent = { char = "┊" },
      scope = { only_current = true },
    },
    dim = {},
    styles = {
      lazygit = {
        styl = "split",
        position = "left",
        width = 0.25,
        resize = true,
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local Snacks = require "snacks"
        -- useful helper for debugging Lua
        _G.v = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        vim.print = _G.v
      end,
    })
  end,

  dependencies = { "folke/noice.nvim" },
  lazy = false,
}
