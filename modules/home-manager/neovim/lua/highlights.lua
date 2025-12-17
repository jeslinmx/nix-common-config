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
hl.MiniStatuslineModeVisual = { fg = _G.palette.base00, bg = _G.palette.base0B }
hl.MiniStatuslineModeReplace = { fg = _G.palette.base00, bg = _G.palette.base0E }

hl.MiniDiffOverAdd = { bg = blend(hl.DiffAdd.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverDelete = { bg = blend(hl.DiffDelete.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverContext = { bg = blend(hl.DiffChange.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverContextBuf = { bg = blend(hl.DiffChange.fg, hl.Normal.bg, 0.1) }
hl.MiniDiffOverChange = { bg = blend(hl.DiffDelete.fg, hl.Normal.bg, 0.2) }
hl.MiniDiffOverChangeBuf = { bg = blend(hl.DiffAdd.fg, hl.Normal.bg, 0.2) }
