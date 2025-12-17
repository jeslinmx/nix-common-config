_: {pkgs, ...}: {
  vim.lazy.plugins = {
    vim-speeddating = {package = pkgs.vimPlugins.vim-speeddating;};
    vim-repeat = {package = "vim-repeat";};
  };
}
