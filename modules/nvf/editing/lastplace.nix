_: {pkgs, ...}: {
  vim.lazy.plugins.vim-lastplace = {
    package = pkgs.vimPlugins.vim-lastplace;
    event = "BufRead";
  };
}
