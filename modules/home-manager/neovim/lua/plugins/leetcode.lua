local leet_arg = "leetcode"
return {
  "kawre/leetcode.nvim",
  opts = {
    arg = leet_arg,
    lang = "python3",
    picker = { provider = "telescope" },
  },

  cmd = "Leet",
  lazy = leet_arg ~= vim.fn.argv(0, -1),
}
