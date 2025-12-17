_: {...}: {
  vim.luaConfigRC = {
    nvr = ''
      vim.env.EDITOR = "nvr -l --remote-wait"
      vim.env.MANPAGER = "nvr -c Man!"
    '';
  };
}
