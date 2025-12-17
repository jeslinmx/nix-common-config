_: {pkgs, ...}: {
  vim.lazy.plugins = {
    vim-eunuch = {
      package = pkgs.vimPlugins.vim-eunuch;
      cmd = [
        "Remove"
        "Unlink"
        "Delete"
        "Copy"
        "Duplicate"
        "Move"
        "Rename"
        "Chmod"
        "Mkdir"
        "Cfind"
        "Lfind"
        "Clocate"
        "Llocate"
        "SudoEdit"
        "SudoWrite"
        "Wall"
        "W"
      ];
    };
  };
}
