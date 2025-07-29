local map = vim.keymap.set

map("i", "<C-a>", "<Home>", { desc = "move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move to end of line" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<cr>", { desc = "clear highlights" })

map("i", "jj", "<Esc>", { desc = "escape insert mode" })
map("t", "jj", "<C-\\><C-N>", { desc = "escape terminal mode" })

map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "copy whole file" })

-- editor
map("n", "<leader>ed", Snacks.dim.enable, { desc = "dim outside of scope" })
map("n", "<leader>eD", Snacks.dim.enable, { desc = "undim" })

-- git
map("n", "<leader>gb", Snacks.git.blame_line, { desc = "blame current line" })
map("n", "<leader>gg", Snacks.lazygit.open, { desc = "open lazygit" })
map("n", "<leader>gl", Snacks.lazygit.log_file, { desc = "open file log (lazygit)" })
map("n", "<leader>gL", Snacks.lazygit.log, { desc = "open repo log (lazygit)" })

-- tabufline
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "buffer new" })
map("n", "<leader>bq", require("mini.bufremove").delete, { desc = "buffer close" })
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "buffer goto next" })
map("n", "<S-tab>", "<cmd>bprev<cr>", { desc = "buffer goto prev" })

-- terminals
map({ "n", "t" }, "<C-\\>", require("snacks").terminal.toggle, { desc = "toggle terminals" })

-- leap
map("n", "s", "<Plug>(leap)", { desc = "Leap" })
map("n", "S", "<Plug>(leap-from-window)", { desc = "Leap across windows" })
map({ "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
map({ "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
map({ "n", "o" }, "gs", function()
  require("leap.remote").action()
end, { desc = "Leap temporarily" })

map("n", "-", function()
  require("mini.files").open(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"))
  require("mini.files").reveal_cwd()
end, { desc = "browse containing folder " })
map("n", "<leader><leader><leader>", function()
  require("snacks").dashboard()
end, { desc = "Open dashboard" })

-- LSP
map("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "<leader>l.", vim.lsp.buf.code_action, { desc = "Show code actions" })
map("n", "<leader>lr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "Show signature help" })
map("n", "<leader>la", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map("n", "<leader>lx", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map("n", "<leader>ll", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })
map("n", "<leader>lc", vim.lsp.buf.rename, { desc = "Go to type definition" })
-- map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Trouble
map("n", "<leader>td", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Diagnostics" })
map("n", "<leader>tl", "<cmd>Trouble loclist toggle focus=true<cr>", { desc = "Locations" })
map("n", "<leader>tt", "<cmd>Trouble lsp toggle focus=true<cr>", { desc = "LSP" })
map("n", "<leader>tq", "<cmd>Trouble quickfix toggle focus=true<cr>", { desc = "Quickfixes" })
map("n", "<leader>ts", "<cmd>Trouble symbols toggle focus=true<cr> win.position=left", { desc = "Symbols" })

-- Telescope
-- map("n", "<leader><leader>a", "<cmd>Telescope autocommands<cr>", { desc = "autocommands" })
map("n", "<leader><leader>b", "<cmd>Telescope buffers<cr>", { desc = "buffers" })
-- map("n", "<leader><leader>c", "<cmd>Telescope commands<cr>", { desc = "commands" })
map("n", "<leader><leader>f", "<cmd>Telescope find_files<cr>", { desc = "files" })
map(
  "n",
  "<leader><leader>F",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>",
  { desc = "all files" }
)
map("n", "<leader><leader>r", "<cmd>Telescope live_grep<cr>", { desc = "ripgrep" })
map("n", "<leader><leader>:", "<cmd>Telescope command_history<cr>", { desc = "command history" })
map("n", "<leader><leader>h", "<cmd>Telescope help_tags<cr>", { desc = "help" })
map("n", "<leader><leader>j", "<cmd>Telescope jumplist<cr>", { desc = "jumps" })
map("n", "<leader><leader>m", "<cmd>Telescope man_pages<cr>", { desc = "man" })
map("n", "<leader><leader>n", "<cmd>Noice telescope<cr>", { desc = "notifications" })
map("n", "<leader><leader>t", "<cmd>Telescope filetypes<cr>", { desc = "filetypes" })
map("n", "<leader><leader>q", "<cmd>Telescope oldfiles<cr>", { desc = "recently closed" })
map("n", "<leader><leader>u", "<cmd>Telescope undo<cr>", { desc = "undotree" })
map("n", "<leader><leader>o", "<cmd>Telescope vim_options<cr>", { desc = "options" })
map("n", "<leader><leader>'", "<cmd>Telescope marks<cr>", { desc = "marks" })
map("n", '<leader><leader>"', "<cmd>Telescope registers<cr>", { desc = "registers" })
map("n", "<leader><leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "current buffer (fuzzy)" })

map("n", "<leader><leader>gc", "<cmd>Telescope git_bcommits<cr>", { desc = "commits (current file)" })
map({ "n", "v" }, "<leader><leader>gc", "<cmd>Telescope git_bcommits_range<cr>", { desc = "commits (range)" })
map("n", "<leader><leader>gC", "<cmd>Telescope git_commits<cr>", { desc = "commits (working dir)" })
map("n", "<leader><leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "branches" })
map("n", "<leader><leader>gf", "<cmd>Telescope git_files<cr>", { desc = "files" })
map("n", "<leader><leader>gs", "<cmd>Telescope git_stash<cr>", { desc = "stash" })
map("n", "<leader><leader>gd", "<cmd>Telescope git_status<cr>", { desc = "diff/status" })

-- Leetcode
map("n", "<leader>ct", "<cmd>Leet tabs<cr>", { desc = "Tabs" })
map("n", "<leader>ci", "<cmd>Leet info<cr>", { desc = "Info" })
map("n", "<leader>cr", "<cmd>Leet reset<cr>", { desc = "Reset" })
map("n", "<leader>cl", "<cmd>Leet last_submit<cr>", { desc = "Last submission" })
map("n", "<leader>cL", "<cmd>Leet lang<cr>", { desc = "Language" })
map("n", "<leader>cC", "<cmd>Leet console<cr>", { desc = "Console" })
map("n", "<leader>cf", "<cmd>Leet fold<cr>", { desc = "Fold" })
map("n", "<leader>cc", "<cmd>Leet menu<cr>", { desc = "Menu" })
map("n", "<leader>c<s-cr>", "<cmd>Leet submit<cr>", { desc = "Submit" })
map("n", "<leader>ct", "<cmd>Leet desc<cr>", { desc = "Description" })
map("n", "<leader>c<cr>", "<cmd>Leet run<cr>", { desc = "Run" })
map("n", "<leader>ch", "<cmd>Leet hints<cr>", { desc = "Hints" })
map("n", "<leader>cy", "<cmd>Leet yank<cr>", { desc = "Yank" })
map("n", "<leader>cb", "<cmd>Leet open<cr>", { desc = "Open in browser" })

map("n", "<leader>cpp", "<cmd>Leet list<cr>", { desc = "List" })
map("n", "<leader>cpd", "<cmd>Leet daily<cr>", { desc = "Daily" })
map("n", "<leader>cpr", "<cmd>Leet random<cr>", { desc = "Random" })
