local map = vim.keymap.set
local Snacks = require "snacks"

map("i", "<C-a>", "<Home>", { desc = "move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move to end of line" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "copy whole file" })

map("i", "jj", "<Esc>", { desc = "escape insert mode" })
map("t", "jj", "<C-\\><C-N>", { desc = "escape terminal mode" })

map("n", "<Esc>", "<cmd>noh<cr>", { desc = "clear highlights" })
map("n", "-", function()
  require("mini.files").open(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"))
  require("mini.files").reveal_cwd()
end, { desc = "browse containing folder" })

-- terminals
map({ "n", "t" }, "<C-\\>", Snacks.terminal.toggle, { desc = "create/toggle terminal" })
map({ "n", "t" }, "<C-A-\\>", function()
  return Snacks.terminal.toggle(nil, { win = { position = "right" } })
end, { desc = "create/toggle v-terminal" })

-- leap
map("n", "s", "<Plug>(leap)", { desc = "leap" })
map("n", "S", "<Plug>(leap-from-window)", { desc = "leap across windows" })
map({ "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "leap forward" })
map({ "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "leap backward" })
map({ "n", "o" }, "gs", function()
  require("leap.remote").action()
end, { desc = "leap temporarily" })

-- tabufline
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "buffer goto next" })
map("n", "<S-tab>", "<cmd>bprev<cr>", { desc = "buffer goto prev" })

-- ## LEADER KEYBINDS ## --
map("n", "<leader><leader>", Snacks.dashboard.open, { desc = "Open dashboard" })

-- editor
map("n", "<leader>ed", Snacks.dim.enable, { desc = "dim outside of scope" })
map("n", "<leader>eD", Snacks.dim.disable, { desc = "undim" })

-- git
map("n", "<leader>gg", Snacks.lazygit.open, { desc = "lazygit" })
map("n", "<leader>gb", Snacks.picker.git_log_line, { desc = "blame line" })
map("n", "<leader>gB", Snacks.picker.git_branches, { desc = "branches" })
map("n", "<leader>gf", Snacks.picker.git_files, { desc = "files" })
map("n", "<leader>g/", Snacks.picker.git_grep, { desc = "grep" })
map("n", "<leader>gl", Snacks.picker.git_log_file, { desc = "log" })
map("n", "<leader>gL", Snacks.picker.git_log, { desc = "repo log" })
map("n", "<leader>gs", Snacks.picker.git_status, { desc = "status" })
map("n", "<leader>gS", Snacks.picker.git_stash, { desc = "stash" })

-- buffers
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "new" })
map("n", "<leader>bq", require("mini.bufremove").delete, { desc = "close" })
map("n", "<leader>bb", Snacks.picker.buffers, { desc = "picker" })

-- LSP
map("n", "<leader>d", Snacks.picker.diagnostics_buffer, { desc = "diagnostics (buffer)" })
map("n", "<leader>D", Snacks.picker.diagnostics, { desc = "diagnostics (project)" })
map("n", "<leader>lc", Snacks.picker.lsp_config, { desc = "config" })
map("n", "<leader>ld", Snacks.picker.lsp_definitions, { desc = "definitions" })
map("n", "<leader>lD", Snacks.picker.lsp_declarations, { desc = "declarations" })
map("n", "<leader>li", Snacks.picker.lsp_implementations, { desc = "implementations" })
map("n", "<leader>lr", Snacks.picker.lsp_references, { desc = "references" })
map("n", "<leader>ls", Snacks.picker.lsp_symbols, { desc = "symbols" })
map("n", "<leader>lt", Snacks.picker.lsp_type_definitions, { desc = "type definitions" })
map("n", "<leader>la", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
map("n", "<leader>lx", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })

-- Leetcode
map("n", "<leader>1t", "<cmd>Leet tabs<cr>", { desc = "tabs" })
map("n", "<leader>1i", "<cmd>Leet info<cr>", { desc = "info" })
map("n", "<leader>1x", "<cmd>Leet reset<cr>", { desc = "reset" })
map("n", "<leader>1l", "<cmd>Leet last_submit<cr>", { desc = "last submission" })
map("n", "<leader>1L", "<cmd>Leet lang<cr>", { desc = "language" })
map("n", "<leader>1c", "<cmd>Leet console<cr>", { desc = "console" })
map("n", "<leader>1f", "<cmd>Leet fold<cr>", { desc = "fold" })
map("n", "<leader>1m", "<cmd>Leet menu<cr>", { desc = "menu" })
map("n", "<leader>1R", "<cmd>Leet submit<cr>", { desc = "submit" })
map("n", "<leader>1d", "<cmd>Leet desc<cr>", { desc = "description" })
map("n", "<leader>1r", "<cmd>Leet run<cr>", { desc = "run" })
map("n", "<leader>1h", "<cmd>Leet hints<cr>", { desc = "hints" })
map("n", "<leader>1y", "<cmd>Leet yank<cr>", { desc = "yank" })
map("n", "<leader>1b", "<cmd>Leet open<cr>", { desc = "open in browser" })
map("n", "<leader>1pp", "<cmd>Leet list<cr>", { desc = "list" })
map("n", "<leader>1pd", "<cmd>Leet daily<cr>", { desc = "daily" })
map("n", "<leader>1pr", "<cmd>Leet random<cr>", { desc = "random" })
-- other pickers
map("n", "<leader>a", Snacks.picker.autocmds, { desc = "autocmds" })
map("n", "<leader>c", Snacks.picker.commands, { desc = "commands" })
map("n", "<leader>f", Snacks.picker.explorer, { desc = "files" })
map("n", "<leader>F", function()
  Snacks.picker.explorer { hidden = true, ignored = true }
end, { desc = "all files" })
map("n", "<leader>h", Snacks.picker.highlights, { desc = "highlights" })
map("n", "<leader>i", Snacks.picker.icons, { desc = "icons" })
map("n", "<leader>j", Snacks.picker.jumps, { desc = "jumps" })
map("n", "<leader>k", Snacks.picker.keymaps, { desc = "keymaps" })
map("n", "<leader>L", Snacks.picker.lazy, { desc = "lazy" })
map("n", "<leader>m", Snacks.picker.man, { desc = "man" })
map("n", "<leader>n", Snacks.picker.noice, { desc = "notifications" })
map("n", "<leader>o", Snacks.picker.resume, { desc = "open last picker" })
map("n", "<leader>p", Snacks.picker.projects, { desc = "projects" })
map("n", "<leader>Pa", Snacks.picker.picker_actions, { desc = "picker actions" })
map("n", "<leader>Pf", Snacks.picker.picker_format, { desc = "picker format" })
map("n", "<leader>Pl", Snacks.picker.picker_layouts, { desc = "picker layouts" })
map("n", "<leader>Pp", Snacks.picker.picker_preview, { desc = "picker preview" })
map("n", "<leader>r", Snacks.picker.recent, { desc = "recent" })
map("n", "<leader>s", Snacks.picker.spelling, { desc = "spelling" })
map("n", "<leader>t", Snacks.picker.treesitter, { desc = "treesitter" })
map("n", "<leader>u", Snacks.picker.undo, { desc = "undo" })
map("n", "<leader>v", Snacks.picker.cliphist, { desc = "cliphist" })
map("n", "<leader>z", Snacks.picker.zoxide, { desc = "zoxide" })
map("n", '<leader>"', Snacks.picker.registers, { desc = "registers" })
map("n", "<leader>'", Snacks.picker.marks, { desc = "marks" })
map("n", "<leader>.", Snacks.picker.qflist, { desc = "quickfixes" })
map("n", "<leader>/", Snacks.picker.grep, { desc = "grep" })
map("n", "<leader>?", Snacks.picker.help, { desc = "help" })
map("n", "<leader>-", Snacks.picker.explorer, { desc = "explorer" })
map("n", "<leader>:", Snacks.picker.command_history, { desc = "command history" })
-- q
-- w
-- x
-- y

-- map("n", "<leader><leader>t", Snacks.picker.buffers, { desc = "filetypes" })
-- map("n", "<leader><leader>o", Snacks.picker.buffers, { desc = "options" })
