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
            local MiniFiles = require "mini.files"
            local show_dotfiles = false
            local filter_show = function(_) return true end
            local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
            local toggle_dotfiles = function()
              show_dotfiles = not show_dotfiles
              local new_filter = show_dotfiles and filter_show or filter_hide
              MiniFiles.refresh { content = { filter = new_filter } }
            end
            vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = args.data.buf_id })
            MiniFiles.refresh { content = { filter = filter_hide } }
          end
        '';
      }
    ];
    keymaps = [
      (lib.nvim.binds.mkKeymap ["n" "v"] "-" ''
          function()
            require("mini.files").open(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"))
            require("mini.files").reveal_cwd()
          end
        '' {
          desc = "browse containing folder";
          lua = true;
        })
    ];
  };
}
