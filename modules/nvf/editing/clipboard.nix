_: {lib, ...}: {
  # vim.options.clipboard = "unnamedplus";
  # over SSH, yank to vim buffer, but if clipboard explicitly invoked, use osc52
  vim.luaConfigRC.ssh-osc52 = lib.nvim.dag.entryAfter ["optionsScript"] ''
    if vim.env.SSH_TTY then
      vim.o.clipboard = ""
      g.clipboard = "osc52"
    end
  '';
}
