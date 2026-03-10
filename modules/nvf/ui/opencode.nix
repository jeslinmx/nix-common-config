_: {
  lib,
  pkgs,
  ...
}: {
  vim = {
    extraPlugins.opencode-nvim.package = pkgs.vimPlugins.opencode-nvim;
    globals.opencode_opts = {
      server = {
        start = lib.generators.mkLuaInline ''
          function() require('snacks.terminal').open(vim.g.opencode_opts.opencode_cmd, vim.g.opencode_opts.snacks_terminal_opts) end
        '';
        stop = lib.generators.mkLuaInline ''
          function() require('snacks.terminal').get(vim.g.opencode_opts.opencode_cmd, vim.g.opencode_opts.snacks_terminal_opts):close() end
        '';
        toggle = lib.generators.mkLuaInline ''
          function() require('snacks.terminal').toggle(vim.g.opencode_opts.opencode_cmd, vim.g.opencode_opts.snacks_terminal_opts) end
        '';
      };
      opencode_cmd = "opencode --port";
      snacks_terminal_opts = {
        win = {
          position = "right";
          enter = false;
          on_win = lib.generators.mkLuaInline ''function(win) require('opencode.terminal').setup(win.win) end'';
        };
      };
    };
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
