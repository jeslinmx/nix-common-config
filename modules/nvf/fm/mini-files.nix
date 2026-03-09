_: {lib, ...}: {
  vim = let
    augroup = "mini-files-binds";
  in {
    mini.files = {
      enable = true;
      setupOpts = {
        windows = {
          preview = true;
          width_focus = 25;
          width_nofocus = 15;
          width_preview = 50;
        };
        mappings = {
          close = "<Esc>";
          go_in = "<S-CR>";
          go_in_plus = "<CR>";
          go_out = "_";
          go_out_plus = "-";
        };
      };
    };
    augroups = [{name = augroup;}];
    autocmds = [
      {
        event = ["User"];
        pattern = ["MiniFilesBufferCreate"];
        group = augroup;
        callback = lib.generators.mkLuaInline ''
          function(args)
            vim.keymap.set("n", "g.", "<cmd>MiniFilesToggleHidden<cr>", { buffer = args.data.buf_id })
          end
        '';
      }
    ];
    keymaps = [
      (lib.nvim.binds.mkKeymap ["n" "v"] "-" ''
          function()
            require("mini.files").open(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"), false, {
              content = { filter = vim.g.mini_files_filter }
            })
            require("mini.files").reveal_cwd()
          end
        '' {
          desc = "browse containing folder";
          lua = true;
        })
    ];
    luaConfigRC.miniFiles-configureBorder = lib.nvim.dag.entryAfter ["pluginConfigs"] ''
      ;(function()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesWindowOpen',
          callback = function(args)
            local win_id = args.data.win_id
            local config = vim.api.nvim_win_get_config(win_id)
            config.border = 'rounded'
            vim.api.nvim_win_set_config(win_id, config)
          end,
        })
      end)()
    '';
    luaConfigRC.miniFiles-createToggleHiddenCommand = lib.nvim.dag.entryAfter ["pluginConfigs"] ''
      ;(function()
        local MiniFiles = require "mini.files"
        local filter_show = function(_) return true end
        local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
        vim.g.mini_files_filter = filter_hide
        vim.api.nvim_create_user_command("MiniFilesToggleHidden", function()
          vim.g.mini_files_filter = (vim.g.mini_files_filter == filter_hide) and filter_show or filter_hide
          MiniFiles.refresh { content = { filter = vim.g.mini_files_filter } }
        end, {desc = "Toggle hidden files visibility in MiniFiles"})
      end)()
    '';
  };
}
