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
    statusline.lualine.activeSection.y = lib.mkBefore [''{ require("opencode").statusline }''];
    keymaps = let
      inherit (lib.nvim.binds) mkKeymap;
    in [
      (mkKeymap ["n" "v"] "<leader>oa" ''require("opencode").ask'' {
        desc = "ask";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>oA" ''
          function()
            require("opencode").command("session.new")
            require("opencode").ask()
          end
        '' {
          desc = "ask in new session";
          lua = true;
        })
      (mkKeymap ["n" "v"] "<leader>ot" ''require("opencode").toggle'' {
        desc = "toggle";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>os" ''require("opencode").select_session'' {
        desc = "sessions";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>oS" ''require("opencode").select_server'' {
        desc = "servers";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>oo" ''require("opencode").select'' {
        desc = "picker";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>on" ''function() require("opencode").command("session.new") end'' {
        desc = "new session";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>ox" ''function() require("opencode").command("session.interrupt") end'' {
        desc = "interrupt";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>oc" ''function() require("opencode").command("session.compact") end'' {
        desc = "compact";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>ou" ''function() require("opencode").command("session.undo") end'' {
        desc = "undo";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>or" ''function() require("opencode").command("session.redo") end'' {
        desc = "redo";
        lua = true;
      })
      (mkKeymap ["n" "v"] "<leader>o<tab>" ''function() require("opencode").command("agent.cycle") end'' {
        desc = "agent";
        lua = true;
      })
    ];
    luaConfigRC.opencode-group = lib.nvim.dag.entryAfter ["pluginConfigs"] ''
      require("which-key").add({"<leader>o", group = "opencode", icon = { icon = " ", color = "yellow" }})
    '';
    extraPackages = [pkgs.lsof];
  };
}
