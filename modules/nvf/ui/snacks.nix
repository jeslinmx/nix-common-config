{nvfModules, ...}: {
  config,
  lib,
  ...
}: {
  imports = with nvfModules; [ui-snacks-dashboard ui-snacks-pickers];
  vim.utility.snacks-nvim = {
    enable = true;
    setupOpts = {
      lazygit = {
        config = {
          # wait for https://github.com/folke/snacks.nvim/issues/2582
          # customCommands = {
          #   {
          #     key = "c";
          #     context = "files";
          #     command = 'nvr -c \'lua Snacks.terminal("meteor", {win = {style = "lazygit"}})\'';
          #     description = "Create new conventional commit";
          #     loadingText = "Creating conventional commit...";
          #   };
          # };
          os = let
            nvrBaseCommand = "nvr -c ':lua Snacks.lazygit.open()' ";
            reopenOnDelete = "-c ':autocmd snacks_lazygit_suspend BufDelete <buffer> ++once lua Snacks.lazygit.open()' ";
          in {
            edit = "${nvrBaseCommand} --remote {{filename}}";
            editAtLine = "${nvrBaseCommand} --remote {{filename}} -c ':{{line}}'";
            editAtLineAndWait = "${nvrBaseCommand} ${reopenOnDelete} --remote-wait {{filename}} -c ':{{line}}'";
            openDirInEditor = "nvr -c ':lua Snacks.lazygit.open()' -c ':lua MiniFiles.open({{dir}}, false)'";
            editInTerminal = false;
          };
        };
        theme = {
          activeBorderColor = {fg = "ColorfulWinSep";};
          inactiveBorderColor = {fg = "WinSeparator";};
        };
      };
      bigfile = {};
      quickfile = {};
      terminal = {};
      scroll = {};
      indent = {
        indent = {char = "┊";};
        scope = {only_current = true;};
      };
      styles = {
        lazygit = {
          keys = {
            hide = {
              "@1" = "<esc>";
              "@2" = "hide";
              mode = ["n" "t"];
            };
          };
          backdrop = false;
          minimal = true;
        };
        terminal = {
          wo = {winbar = "";};
        };
      };
    };
  };
  vim.keymaps = let
    inherit (lib.nvim.binds) mkKeymap;
  in [
    (mkKeymap ["n" "i" "v" "t"] "<C-\\>" "Snacks.terminal.toggle" {
      desc = "create/toggle terminal";
      lua = true;
    })
    (mkKeymap ["n" "i" "v" "t"] "<C-A-\\>" ''function() return Snacks.terminal.toggle(nil, { win = { position = "right" } }) end'' {
      desc = "create/toggle v-terminal";
      lua = true;
    })
    (mkKeymap ["n" "v"] "<leader>gg" "Snacks.lazygit.open" {
      desc = "lazygit";
      lua = true;
    })
  ];
  vim.luaConfigRC = {
    snacks-debug-bind = lib.nvim.dag.entryAfter ["pluginConfigs"] ''
      _G.v = Snacks.debug.inspect
      _G.bt = Snacks.debug.backtrace
      vim.print = _G.v
    '';
  };
  vim.highlight = {
    # make indent indicators less obvious
    SnacksIndent.fg = config.vim.theme.base16-colors.base03;
  };
}
