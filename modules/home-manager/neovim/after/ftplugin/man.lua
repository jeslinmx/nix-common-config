-- TODO: allow a simple "q" to quit neovim entirely if there are no other buffers open
vim.keymap.set("n", "q", require("mini.bufremove").delete, { remap = false, buffer = true })
