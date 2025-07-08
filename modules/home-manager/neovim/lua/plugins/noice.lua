return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },

  opts = {
    cmdline = {
      view = "cmdline_popup",
      format = {
        cmdline = { icon = ":", title = "" },
        search_up = { icon = " " },
        search_down = { icon = " " },
        filter = false,
        exec = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        pipe = { pattern = "^:[^A-Za-z]+!", icon = "|", lang = "bash" },
        rpipe = { pattern = "^:%S*r%s+!", icon = "<", lang = "bash", title = "Read from command" },
        wpipe = { pattern = "^:%S*w%s+!", icon = ">", lang = "bash", title = "Write into command" },
        help = { icon = "?" },
      },
    },
    views = {
      cmdline_popup = {
        position = { row = 2 },
        size = { min_width = 40, width = "40%" },
        zindex = 200,
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          min_width = 40,
          width = "40%",
          min_height = 10,
          height = "30%",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = {
            Normal = "NoiceCmdlinePopup",
            FloatTitle = "NoiceCmdlinePopupTitle",
            FloatBorder = "NoiceCmdlinePopupBorder",
            IncSearch = "",
            CurSearch = "",
            Search = "",
          },
        },
        zindex = 199,
      },
      mini = {
        timeout = 2000,
        reverse = false,
        size = {
          width = "auto",
          height = "auto",
          max_width = 60,
          max_height = 10,
        },
      },
    },
    format = (function()
      local summary = {
        "{date} ",
        "{level}",
        "{title} ",
        "{message}",
      }
      local preview = {
        "{date} ",
        "{level}",
        "{title} ",
        "{event} ",
        { "{kind}", before = { ".", hl_group = "NoiceFormatKind" } },
        "\n---\n",
        "{message}",
      }
      return {
        telescope = summary,
        fzf = summary,
        snacks = summary,
        telescope_preview = preview,
        fzf_preview = preview,
        snacks_preview = preview,
      }
    end)(),
  },
  -- wrap messages

  event = "VeryLazy",
}
