_: {config, ...}: {
  vim.lazy.plugins.modes-nvim = {
    package = "modes-nvim";
    setupModule = "modes";
    setupOpts = {
      colors = let
        inherit (config.vim.theme.base16-colors) base07 base08 base0C base0D base0E base0F;
      in {
        insert = base0D;
        visual = base0C;
        select = base0C;
        copy = base0F;
        delete = base08;
        change = base0E;
        replace = base0E;
        format = base07;
      };
      # Set opacity for cursorline and number background
      line_opacity = 0.3;

      # Enable cursor highlights
      set_cursor = true;

      # Enable cursorline initially, and disable cursorline for inactive windows or ignored filetypes
      set_cursorline = true;

      # Enable line number highlights to match cursorline
      set_number = true;

      # Enable sign column highlights to match cursorline
      set_signcolumn = true;

      # Disable modes highlights for specified filetypes
      # or enable with prefix "!" if otherwise disabled (please PR common patterns)
      # Can also be a function fun():boolean that disables modes highlights when true
      ignore = ["NvimTree" "TelescopePrompt" "!minifiles"];
    };
  };
}
