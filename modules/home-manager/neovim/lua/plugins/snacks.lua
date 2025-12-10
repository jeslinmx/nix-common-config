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
            icon = " ",
            key = "c",
            desc = "CodeCompanion",
            action = ":CodeCompanionActions",
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
        undo = { layout = "dropdown", sort = { fields = { "idx" } } },
        explorer = {
          focus = "input",
          auto_close = true,
          win = { list = { keys = { ["<cr>"] = "confirm" } } },
          layout = { preview = "main" },
        },
        filetypes = {
          name = "filetypes",
          format = "text",
          preview = "none",
          layout = { preset = "vscode" },
          confirm = function(picker, item)
            picker:close()
            if item then
              vim.schedule(function()
                vim.cmd("setfiletype " .. item.text)
              end)
            end
          end,
          finder = function()
            local items = {}
            local filetypes = vim.fn.getcompletion("", "filetype")
            for _, type in ipairs(filetypes) do
              items[#items + 1] = {
                text = type,
              }
            end
            return items
          end,
        },
      },
      layouts = {
        default = {
          layout = {
            backdrop = false,
            box = "horizontal",
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              {
                win = "input",
                title = "{title} {live} {flags}",
                border = { "╭", "─", "┬", "│", "┤", "─", "├", "│" },
                height = 1,
              },
              { win = "list", border = { "", "", "", "╎", "┴", "─", "╰", "│" } },
            },
            {
              win = "preview",
              title = "{preview}",
              border = { "", "─", "╮", "│", "╯", "─", "", "" },
              width = 0.5,
            },
          },
        },
        dropdown = {
          preset = "vertical",
          layout = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.8,
            box = "vertical",
            {
              win = "input",
              height = 1,
              border = { "╭", "─", "╮", "│", "┤", "─", "├", "│" },
              title = "{title} {live} {flags}",
            },
            { win = "list", border = { "", "", "", "│", "", "", "", "│" } },
            {
              win = "preview",
              title = "{preview}",
              height = 0.4,
              border = { "├", "╌", "┤", "│", "╯", "─", "╰", "│" },
            },
          },
        },
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1 },
            {
              box = "horizontal",
              { win = "list", border = { "", "─", "┬", "╎", "╎", "", "", "" } },
              { win = "preview", title = "{preview}", width = 0.6, border = { "", "─", "", "", "", "", "", "" } },
            },
          },
        },
        select = {
          hidden = { "preview" },
          layout = {
            backdrop = false,
            width = 0.5,
            min_width = 80,
            max_width = 100,
            height = 0.4,
            min_height = 2,
            box = "vertical",
            {
              win = "input",
              title = "{title}",
              height = 1,
              border = { "╭", "─", "╮", "│", "┤", "─", "├", "│" },
            },
            { win = "list", border = { "", "", "", "│", "╯", "─", "╰", "│" } },
          },
        },
        vertical = {
          layout = {
            backdrop = false,
            width = 0.5,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = "vertical",
            {
              win = "input",
              height = 1,
              border = { "╭", "─", "╮", "│", "┤", "─", "├", "│" },
              title = "{title} {live} {flags}",
            },
            { win = "list", border = { "", "", "", "│", "", "", "", "│" } },
            {
              win = "preview",
              title = "{preview}",
              height = 0.4,
              border = { "├", "╌", "┤", "│", "╯", "─", "╰", "│" },
            },
          },
        },
        telescope = { reverse = false },
        vscode = {
          layout = {
            backdrop = true,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.4,
            border = "none",
            box = "vertical",
            { win = "input", height = 1, border = "solid", title = "{title} {live} {flags}" },
            { win = "list", border = "hpad" },
            { win = "preview", title = "{preview}", border = true },
          },
        },
      },
    },
    lazygit = {
      config = {
        -- wait for https://github.com/folke/snacks.nvim/issues/2582
        -- customCommands = {
        --   {
        --     key = "c",
        --     context = "files",
        --     command = 'nvr -c \'lua Snacks.terminal("meteor", {win = {style = "lazygit"}})\'',
        --     description = "Create new conventional commit",
        --     loadingText = "Creating conventional commit...",
        --   },
        -- },
      },
      theme = {
        activeBorderColor = { fg = "ColorfulWinSep" },
        inactiveBorderColor = { fg = "WinSeparator" },
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
      lazygit = { keys = { hide = { "q", "hide", mode = "t" } }, backdrop = false, minimal = true },
      -- lazygit = { style = "split", minimal = true, stack = true },
      terminal = {
        wo = { winbar = "" },
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
