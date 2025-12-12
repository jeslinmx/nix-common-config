_G.hl = setmetatable({}, {
  __index = function(_, hl)
    return vim.api.nvim_get_hl(0, { name = hl })
  end,
  __newindex = function(_, hl, v)
    return vim.api.nvim_set_hl(0, hl, v)
  end,
})
_G.numToRgb = function(color)
  return { bit.band(bit.rshift(color, 16), 255), bit.band(bit.rshift(color, 8), 255), bit.band(color, 255) }
end
_G.rgbToNum = function(ctbl)
  return ctbl[1] * 256 * 256 + ctbl[2] * 256 + ctbl[3]
end
_G.blend = function(color1, color2, alpha)
  local c, c1, c2 = {}, numToRgb(color1), numToRgb(color2)
  for i = 1, 3 do
    c[i] = math.floor(math.sqrt(alpha * c1[i] ^ 2 + (1 - alpha) * c2[i] ^ 2))
  end
  return rgbToNum(c)
end

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

-- make floats more subtle
hl.NormalFloat = { link = "Normal" }
hl.FloatBorder = { fg = hl.WinSeparator.fg }

-- don't style folded sections
hl.Folded = { fg = hl.BufferInactive.fg }

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

hl.MiniDiffOverAdd = { bg = blend(hl.DiffAdd.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverDelete = { bg = blend(hl.DiffDelete.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverContext = { bg = blend(hl.DiffChange.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverContextBuf = { bg = blend(hl.DiffChange.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverChange = { bg = blend(hl.DiffDelete.fg, hl.Normal.bg, 0.2) }
hl.MiniDiffOverChangeBuf = { bg = blend(hl.DiffAdd.fg, hl.Normal.bg, 0.2) }
