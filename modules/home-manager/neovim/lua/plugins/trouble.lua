local open_or_focus = function(opts)
  return function()
    local trouble = require "trouble"
    if not trouble.is_open(opts) then
      trouble.open(opts)
    else
      trouble.focus(opts)
    end
  end
end

return {
  "folke/trouble.nvim",

  opts = {
    open_no_results = true,
    modes = {
      diagnostics = {
        -- filter = function(items)
        --   local severity = vim.diagnostic.severity.HINT
        --   for _, item in ipairs(items) do
        --     severity = math.min(severity, item.severity)
        --   end
        --   return vim.tbl_filter(function(item)
        --     return item.severity == severity
        --   end, items)
        -- end,
      },
    },
  },

  cmd = "Trouble",
}
