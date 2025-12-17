_: {...}: {
  vim.treesitter = {
    enable = true;
    fold = true;
    autotagHtml = true;
    context = {
      enable = true;
      setupOpts = {
        max_lines = 3;
        min_window_height = 30;
        mode = "topline";
        separator = null;
      };
    };
    textobjects = {
      enable = true;
    };
  };
  vim.languages.enableTreesitter = true;
}
