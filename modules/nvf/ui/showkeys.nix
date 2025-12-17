_: {
  lib,
  pkgs,
  ...
}: {
  vim.lazy.plugins.showkeys = {
    package = pkgs.vimPlugins.showkeys;
    setupModule = "showkeys";
    setupOpts = {
      position = "top-right";
      timeout = 1;
      maxkeys = 5;
      show_count = true;
      excluded_modes = ["i" "c"];
      winopts = {border = "none";};
      keyformat = {
        "<C>" = "^";
        "<M>" = "⎇";
        "<BS>" = "⌫";
        "<Esc>" = "󱊷";
        "<CR>" = "↵";
        "<Tab>" = "󰞔";
        "<Space>" = "␣";
        "<Up>" = "↑";
        "<Down>" = "↓";
        "<Left>" = "←";
        "<Right>" = "→";
        "<PageUp>" = "󰞕";
        "<PageDown>" = "󰞒";
      };
    };
  };
  vim.luaConfigRC.showkeys-enable = lib.nvim.dag.entryAfter ["pluginConfigs"] ''require("showkeys").toggle()'';
}
