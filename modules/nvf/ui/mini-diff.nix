_: {
  config,
  lib,
  ...
}: let
  inherit (lib.generators) mkLuaInline;
in {
  vim.mini.diff = {
    enable = true;
    setupOpts = {
      source = mkLuaInline ''
        (function()
          local MiniDiff = require "mini.diff"
          return { MiniDiff.gen_source.git(), MiniDiff.gen_source.save(), MiniDiff.gen_source.none() }
        end)()
      '';
      view.priority = 49;
    };
  };
  vim.highlight = let
    inherit (config.vim.theme.base16-colors) base00 base08 base0B base0E;
  in {
    # use more consistent colors
    MiniDiffSignAdd.fg = base0B;
    MiniDiffSignChange.fg = base0E;
    MiniDiffSignDelete.fg = base08;
    MiniDiffOverAdd.bg = blend base00 base0B 0.5;
    MiniDiffOverDelete.bg = blend base00 base08 0.5;
    MiniDiffOverContext.bg = blend base00 base0E 0.5;
    MiniDiffOverContextBuf.bg = blend base00 base0E 0.5;
    MiniDiffOverChange.bg = blend base00 base08 0.5;
    MiniDiffOverChangeBuf.bg = blend base00 base0B 0.5;
  };
  vim.keymaps = [
    (lib.nvim.binds.mkKeymap ["n"] "yoo" ''require("mini.diff").toggle_overlay'' {
      desc = "toggle diff overlay";
      lua = true;
    })
  ];
}
