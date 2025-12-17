local Mcustom = {}
Mcustom.attached_lsp = {}
local gr = vim.api.nvim_create_augroup("MiniCustom", {})
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
  group = gr,
  pattern = "*",
  desc = "Track LSP clients",
  callback = vim.schedule_wrap(function(data)
    Mcustom.attached_lsp[data.buf] = vim.lsp.get_clients { bufnr = data.buf }
    vim.cmd "redrawstatus"
  end),
})

return {
  "echasnovski/mini.nvim",
  version = "*",

  config = function()
    -- UI

    local MiniStatusline = require "mini.statusline"
    do
      local noice = require "noice"
      -- statusline sections
      local small = 40
      local medium = 75
      local wide = 120
      local xwide = 140
      local C_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
      local C_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
      local modes = setmetatable({
        ["n"] = { "", "NORMAL", "MiniStatuslineModeNormal" },
        ["no"] = { "", "NOR-OP", "MiniStatuslineModeNormal" },
        ["niI"] = { "", "I-NOR1", "MiniStatuslineModeInsert" },
        ["niR"] = { "", "R-NOR1", "MiniStatuslineModeReplace" },
        ["niV"] = { "", "V-NOR1", "MiniStatuslineModeVisual" },
        ["ntT"] = { "", "T-NOR1", "MiniStatuslineModeOther" },
        ["v"] = { "󰈈", "VISUAL", "MiniStatuslineModeVisual" },
        ["V"] = { "󱀦", "V-LINE", "MiniStatuslineModeVisual" },
        [C_V] = { "󱈝", "V-BLCK", "MiniStatuslineModeVisual" },
        ["s"] = { "", "SELECT", "MiniStatuslineModeVisual" },
        ["S"] = { "", "S-LINE", "MiniStatuslineModeVisual" },
        [C_S] = { "󰒅", "S-BLCK", "MiniStatuslineModeVisual" },
        ["i"] = { "󰏫", "INSERT", "MiniStatuslineModeInsert" },
        ["R"] = { "󰯍", "REPLCE", "MiniStatuslineModeReplace" },
        ["c"] = { ":", "COMMND", "MiniStatuslineModeCommand" },
        ["cv"] = { ":", "EXMODE", "MiniStatuslineModeOther" },
        ["t"] = { "", "TERMNL", "MiniStatuslineModeOther" },
        ["r"] = { "", "RETURN", "MiniStatuslineModeOther" },
        ["!"] = { "", "EX-CMD", "MiniStatuslineModeOther" },
      }, {
        __index = function(t, k)
          return string.len(k) > 1 and t[string.sub(k, 1, string.len(k) - 1)]
            or { "?", "UNKNWN", "MiniStatuslineModeOther" }
        end,
      })
      local section_mode = function(args)
        local mode_info = modes[vim.fn.mode(true)]
        return MiniStatusline.is_truncated(args.trunc_width) and { mode_info[1], mode_info[3] }
          or { mode_info[1] .. " " .. mode_info[2], mode_info[3] }
      end
      local section_diff = function(args)
        local summary = vim.b.minidiff_summary
        if MiniStatusline.is_truncated(args.trunc_width) or summary == nil then
          return ""
        end

        local diff = {}
        if vim.fn.get(summary, "n_ranges", 0) > 0 then
          diff[#diff + 1] = "%#diffLine#" .. summary.n_ranges
        end
        if vim.fn.get(summary, "add", 0) > 0 then
          diff[#diff + 1] = "%#diffAdded#" .. summary.add
        end
        if vim.fn.get(summary, "change", 0) > 0 then
          diff[#diff + 1] = "%#diffChanged#" .. summary.change
        end
        if vim.fn.get(summary, "delete", 0) > 0 then
          diff[#diff + 1] = "%#diffRemoved#" .. summary.delete
        end
        return table.concat(diff, " ")
      end
      local section_filetype = function(args)
        local filetype = vim.bo.filetype

        -- Don't show anything if there is no filetype
        if filetype == "" then
          return ""
        end

        -- Add filetype icon
        local icon = MiniIcons ~= nil and MiniIcons.get("filetype", filetype) or ""

        return MiniStatusline.is_truncated(args.trunc_width) and icon or icon .. " " .. filetype
      end
      local section_filename = function(args)
        -- In terminal always use plain name
        if vim.bo.buftype == "terminal" then
          return "[" .. vim.b.snacks_terminal.id .. "] " .. vim.b.term_title
        end
        return MiniStatusline.is_truncated(args.trunc_width) and "%f" or "%F"
      end
      local section_breadcrumbs = function(args)
        return MiniStatusline.is_truncated(args.trunc_width) and ""
          or ("%#SagaSep# » " .. (require("lspsaga.symbol.winbar").get_bar() or ""))
      end
      local section_lastmessage = function(args)
        return noice.api.status.message.has and noice.api.status.message.get() or section_filename(args)
      end
      local section_filestatus = function(args)
        if MiniStatusline.is_truncated(args.trunc_width) then
          return ""
        end

        local flags = {}
        if not vim.bo.modifiable then
          flags[#flags + 1] = "󰏯"
        else
          if vim.bo.readonly then
            flags[#flags + 1] = "󰌾"
          end
          if vim.bo.modified then
            flags[#flags + 1] = "󰏫"
          end
        end
        return table.concat(flags)
      end
      local section_lsp = function(args)
        if MiniStatusline.is_truncated(args.trunc_width) then
          return ""
        end

        local bufnr = vim.api.nvim_get_current_buf()
        if not Mcustom.attached_lsp[bufnr] then
          return ""
        end

        local lsp_list = {}
        for i, v in ipairs(Mcustom.attached_lsp[bufnr]) do
          lsp_list[i] = v.name
        end
        local lsps = table.concat(lsp_list, ",")
        if lsps == "" then
          return ""
        end

        return "󰌵 " .. lsps
      end
      local section_mcphub = function(args)
        if MiniStatusline.is_truncated(args.trunc_width) then
          return ""
        end

        if not vim.g.loaded_mcphub then
          return ""
        end

        return "󰐻 "
          .. (
            vim.g.mcphub_status == nil and "-"
            or (vim.g.mcphub_status == "starting" or vim.g.mcphub_status == "restarting") and "…"
            or vim.g.mcphub_executing and ""
            or (vim.g.mcphub_servers_count or 0)
          )
      end
      local section_fileencoding = function(args)
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        return MiniStatusline.is_truncated(args.trunc_width) and "" or (encoding == "utf-8" and "" or encoding)
      end
      local section_fileformat = function(args)
        return MiniStatusline.is_truncated(args.trunc_width) and ""
          or ({ dos = "", unix = "", mac = "" })[vim.bo.fileformat]
      end
      local section_filesize = function(args)
        local size = vim.fn.getfsize(vim.fn.getreg "%")
        local size_str = size < 1024 and string.format("%dB", size)
          or size < 1048576 and string.format("%.2fKiB", size / 1024)
          or string.format("%.2fMiB", size / 1048576)
        return MiniStatusline.is_truncated(args.trunc_width) and "" or size_str
      end
      local section_location = function(args)
        -- Use virtual column number to allow update when past last column
        if MiniStatusline.is_truncated(args.trunc_width) then
          return "%l %v"
        end

        -- Use `virtcol()` to correctly handle multi-byte characters
        return '%02l/%02L %02v/%02{virtcol("$") - 1}'
      end
      local devinfo_hl, inactive_hl, filename_hl, fileinfo_hl =
        vim.api.nvim_get_hl(0, { name = "MiniStatuslineDevinfo" }),
        vim.api.nvim_get_hl(0, { name = "MiniStatuslineInactive" }),
        vim.api.nvim_get_hl(0, { name = "MiniStatuslineFilename" }),
        vim.api.nvim_get_hl(0, { name = "MiniStatuslineFileinfo" })
      vim.api.nvim_set_hl(0, "MiniStatuslineDevinfoToFilename", { bg = devinfo_hl.bg, fg = filename_hl.bg })
      MiniStatusline.setup {
        content = {
          active = function()
            local mode_text, mode_hl_name = unpack(section_mode { trunc_width = wide })
            local mode_hl = vim.api.nvim_get_hl(0, { name = mode_hl_name })
            vim.api.nvim_set_hl(0, "MiniStatuslineModeToDevinfo", { bg = mode_hl.bg, fg = devinfo_hl.bg })
            return MiniStatusline.combine_groups {
              { hl = mode_hl_name, strings = { mode_text } },
              "%#MiniStatuslineModeToDevinfo#",
              {
                hl = "MiniStatuslineDevinfo",
                strings = {
                  MiniStatusline.section_git { trunc_width = medium, icon = "" },
                  section_diff { trunc_width = small },
                },
              },
              "%#MiniStatuslineDevinfoToFilename#",
              { hl = "MiniStatuslineInactive", strings = {} }, -- reset color

              "%<", -- Mark general truncate point

              {
                hl = "MiniStatuslineFilename",
                strings = {
                  section_filename { trunc_width = xwide },
                  section_filestatus {},
                  -- section_breadcrumbs { trunc_width = medium },
                },
              },
              { hl = "MiniStatuslineInactive", strings = {} }, -- reset color

              "%=", -- End left alignment
              "%=", -- End center alignment

              "%#MiniStatuslineDevinfoToFilename#",
              {
                hl = "MiniStatuslineDevinfo",
                strings = {
                  section_mcphub { trunc_width = medium },
                  section_lsp { trunc_width = medium },
                },
              },
              "%#MiniStatuslineModeToDevinfo#",
              {
                hl = mode_hl_name,
                strings = {
                  section_fileformat { trunc_width = medium },
                  section_filesize { trunc_width = wide },
                  section_fileencoding { trunc_width = small },
                  section_location { trunc_width = wide },
                },
              },
            }
          end,
          inactive = function()
            return MiniStatusline.combine_groups {
              { hl = "MiniStatuslineDevinfo", strings = { (section_mode { trunc_width = wide })[1] } },
              " ",
              {
                hl = "MiniStatuslineDevinfo",
                strings = {
                  MiniStatusline.section_git { trunc_width = medium, icon = "" },
                  section_diff { trunc_width = small },
                },
              },
              "%#MiniStatuslineDevinfoToFilename#",
              { hl = "MiniStatuslineInactive", strings = {} }, -- reset color

              "%<", -- Mark general truncate point

              {
                hl = "MiniStatuslineFilename",
                strings = {
                  section_filename { trunc_width = xwide },
                  section_filestatus {},
                },
              },
              { hl = "MiniStatuslineInactive", strings = {} }, -- reset color

              "%=", -- End left alignment
              "%=", -- End center alignment

              "%#MiniStatuslineDevinfoToFilename#",
              { hl = "MiniStatuslineDevinfo", strings = { section_location { trunc_width = wide } } },
            }
          end,
        },
      }
    end

    require("mini.tabline").setup {
      tabpage_section = "right",
      format = function(buf_id, label)
        local levels = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR }
        local icons = { [vim.diagnostic.severity.WARN] = "", [vim.diagnostic.severity.ERROR] = "" }
        local diag = vim.diagnostic.count(buf_id, { severity = levels })
        local t = {
          MiniIcons.get("filetype", vim.api.nvim_get_option_value("filetype", { buf = buf_id })),
          label,
        }
        for level, icon in ipairs(icons) do
          local n = diag[level] or 0
          if n > 0 then
            table.insert(t, icon)
            table.insert(t, n)
          end
        end
        return " " .. table.concat(t, " ") .. " "
      end,
    }

    -- Editing
    vim.api.nvim_create_autocmd("BufReadPost", {
      once = true,
      callback = function()
        local MiniHipatterns = require "mini.hipatterns"
        MiniHipatterns.setup {
          highlighters = {
            hex_color = MiniHipatterns.gen_highlighter.hex_color(),
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          },
        }
        -- require('mini.move').setup()
        -- require('mini.splitjoin').setup()
      end,
    })

    -- Mappings
    require("mini.bracketed").setup()
    require("mini.clue").setup {
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "i", keys = "<C-x>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        -- mark-radar handles these better
        -- { mode = "n", keys = "'" },
        -- { mode = "n", keys = "`" },
        -- { mode = "x", keys = "'" },
        -- { mode = "x", keys = "`" },
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = "x", keys = "<C-w>" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
        { mode = "n", keys = "[" },
        { mode = "x", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "x", keys = "]" },
        { mode = "n", keys = "yo" },
      },
      clues = (function()
        local c = require "mini.clue"
        return {
          c.gen_clues.builtin_completion(),
          c.gen_clues.g(),
          c.gen_clues.marks(),
          c.gen_clues.registers(),
          c.gen_clues.windows(),
          c.gen_clues.z(),
          { mode = "n", keys = "<leader>b", desc = "+buffers" },
          { mode = "n", keys = "<leader>e", desc = "+editor" },
          { mode = "n", keys = "<leader>g", desc = "+git" },
          { mode = "n", keys = "<leader>l", desc = "+lsp" },
          { mode = "n", keys = "<leader>1", desc = "+leetcode" },
          { mode = "n", keys = "<leader>1p", desc = "+problems" },
        }
      end)(),
      window = { delay = 100, config = { width = "auto" } },
    }

    -- Window/buffer management
    require("mini.sessions").setup { autoread = true, autowrite = true } -- todo: MiniSessions.write and select interactively

    -- LSP-like

    -- Additional commands
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        require("mini.git").setup()
        require("mini.misc").setup()
      end,
    })
  end,

  lazy = false,
}
