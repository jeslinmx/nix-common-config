return {
  {
    "windwp/nvim-autopairs",
    config = function()
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"

      -- autocompletion compatibility
      npairs.setup { map_bs = false, map_cr = false }
      _G._npairs_cr = function()
        if vim.fn.pumvisible() ~= 0 then
          if vim.fn.complete_info({ "selected" }).selected ~= -1 then
            return npairs.esc "<c-y>"
          else
            return npairs.esc "<c-e>" .. npairs.autopairs_cr()
          end
        else
          return npairs.autopairs_cr()
        end
      end
      _G._npairs_bs = function()
        if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
          return npairs.esc "<c-e>" .. npairs.autopairs_bs()
        else
          return npairs.autopairs_bs()
        end
      end
      vim.api.nvim_set_keymap("i", "<cr>", "v:lua._npairs_cr()", { expr = true, noremap = true })
      vim.api.nvim_set_keymap("i", "<bs>", "v:lua._npairs_bs()", { expr = true, noremap = true })

      -- whitespace handling
      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules {
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(" ", " ")
          -- Pair will only occur if the conditional function returns true
          :with_pair(function(opts)
            -- We are checking if we are inserting a space in (), [], or {}
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          -- We only want to delete the pair of spaces when the cursor is as such: ( | )
          :with_del(
            function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
              }, context)
            end
          ),
      }
      -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules {
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
              return opts.char == bracket[2]
            end)
            :with_del(cond.none())
            :use_key(bracket[2])
            -- Removes the trailing whitespace that can occur without this
            :replace_map_cr(function(_)
              return "<C-c>2xi<CR><C-c>O"
            end),
        }
      end
    end,

    event = { "InsertEnter" },
  },
}
