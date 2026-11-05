{
  config,
  lib,
  pkgs,
  ...
}: {
  vim.lazy.plugins."colorful-winsep.nvim" = {
    enabled = config.vim.statusline.lualine.enable && lib.attrByPath ["options" "globalstatus"] false config.vim.statusline.lualine.setupOpts;
    package = pkgs.vimPlugins.colorful-winsep-nvim;
    setupModule = "colorful-winsep";
    setupOpts = {
      border = "rounded";
      indicator_for_2wins = {
        position = "both";
        symbols = {
          start_left = "╭";
          end_left = "╰";
          start_down = "╰";
          end_down = "╯";
          start_up = "╭";
          end_up = "╮";
          start_right = "╮";
          end_right = "╯";
        };
      };
    };
  };
}
