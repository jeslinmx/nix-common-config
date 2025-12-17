_: {...}: {
  vim.binds.whichKey = {
    enable = true;
    setupOpts = {
      preset = "helix";
      sort = ["local" "order" "mod" "alphanum"];
      spec = [
        {
          "@" = "<leader>b";
          group = "buffers";
        }
        {
          "@" = "<leader>g";
          group = "git";
          icon = {
            icon = "󰊢 ";
            color = "red";
          };
        }
        {
          "@" = "<leader>l";
          group = "lsp";
          icon = {
            icon = "󰛨 ";
            color = "blue";
          };
        }
        {
          "@" = "<leader>P";
          group = "pickers";
        }
      ];
    };
  };
}
