_: {...}: {
  vim.treesitter = {
    enable = true;
    fold = true;
    autotagHtml = true;
    context = {
      enable = true;
      setupOpts = {
        multiwindow = true;
        max_lines = 7;
        min_window_height = 15;
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
