_: {
  lib,
  pkgs,
  ...
}: {
  vim = {
    extraPlugins.opencode-nvim.package = pkgs.vimPlugins.opencode-nvim;
    # globals.opencode_opts =
    keymaps = let
      inherit (lib.nvim.binds) mkKeymap;
    in [
      (mkKeymap ["n" "v"] "<leader>oa" ''require("opencode").ask'' {
        desc = "ask";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>oo" ''require("opencode").select'' {
        desc = "select";
        lua = true;
      })
    ];
    luaConfigRC.opencode-group = lib.nvim.dag.entryAfter ["pluginConfigs"] ''
      require("which-key").add({"<leader>o", group = "opencode", icon = { icon = " ", color = "yellow" }})
    '';
    extraPackages = [pkgs.lsof];
  };
}
