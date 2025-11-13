_G.hl = setmetatable({}, {
  __index = function(_, hl)
    return vim.api.nvim_get_hl(0, { name = hl })
  end,
  __newindex = function(_, hl, v)
    return vim.api.nvim_set_hl(0, hl, v)
  end,
})

-- make line number column less obvious
hl.LineNr = { fg = hl.NonText.fg }
hl.LineNrAbove = { link = "LineNr" }
hl.LineNrBelow = { link = "LineNr" }
hl.SignColumn = { link = "LineNr" }
hl.MiniDiffSignAdd = { fg = hl.diffAdded.fg }
hl.MiniDiffSignChange = { fg = hl.diffChanged.fg }
hl.MiniDiffSignDelete = { fg = hl.diffRemoved.fg }
hl.DiagnosticSignOk = { fg = hl.DiagnosticOk.fg }
hl.DiagnosticSignHint = { fg = hl.DiagnosticHint.fg }
hl.DiagnosticSignInfo = { fg = hl.DiagnosticInfo.fg }
hl.DiagnosticSignWarn = { fg = hl.DiagnosticWarn.fg }
hl.DiagnosticSignError = { fg = hl.DiagnosticError.fg }

-- make window separators and indent indicators less obvious
hl.WinSeparator = { fg = hl.StatusLine.bg }
hl.SnacksIndent = { fg = hl.StatusLine.bg }

hl.MiniCursorword = { bold = true }
hl.MiniCursorwordCurrent = { link = "MiniCursorword" }

-- LSP
hl.Comment = { fg = hl.Comment.fg, italic = true }
hl.DiagnosticUnnecessary = { sp = hl.Comment.fg, underdashed = true }
hl.DiagnosticUnderlineOk = { sp = hl.DiagnosticOk.fg, underdouble = true }
hl.DiagnosticUnderlineHint = { sp = hl.DiagnosticHint.fg, underdotted = true }
hl.DiagnosticUnderlineInfo = { sp = hl.DiagnosticInfo.fg, underdotted = true }
hl.DiagnosticUnderlineWarn = { sp = hl.DiagnosticWarn.fg, underline = true }
hl.DiagnosticUnderlineError = { sp = hl.DiagnosticError.fg, undercurl = true }

hl.MiniStatuslineModeInsert = { fg = _G.palette.base00, bg = _G.palette.base0D }
hl.MiniStatuslineModeVisual = { fg = _G.palette.base00, bg = _G.palette.base0B }
hl.MiniStatuslineModeReplace = { fg = _G.palette.base00, bg = _G.palette.base0E }
