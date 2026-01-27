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
    epsilon = 0.0001;
    sqrt = x: let
      helper = tmp: let
        value = (tmp + 1.0 * x / tmp) / 2;
      in
        if (value - tmp) < epsilon && (value - tmp) > -epsilon
        then value
        else helper value;
    in
      if x < epsilon
      then 0
      else helper (1.0 * x);
    toRGB = hex: map (pos: lib.fromHexString (builtins.substring pos 2 hex)) [1 3 5];
    toHex = rgb: "#${builtins.concatStringsSep "" (map lib.toHexString rgb)}";
    blend = c1: c2: r:
      toHex (map
        ({
          fst,
          snd,
        }:
          builtins.floor (sqrt (r * fst * fst + (1 - r) * snd * snd)))
        (lib.zipLists (toRGB c1) (toRGB c2)));
  in {
    # use more consistent colors
    MiniDiffSignAdd.fg = base0B;
    MiniDiffSignChange.fg = base0E;
    MiniDiffSignDelete.fg = base08;
    MiniDiffOverAdd.bg = blend base0B base00 0.1;
    MiniDiffOverDelete.bg = blend base08 base00 0.1;
    MiniDiffOverContext.bg = blend base0E base00 0.1;
    MiniDiffOverContextBuf.bg = blend base0E base00 0.1;
    MiniDiffOverChange.bg = blend base08 base00 0.2;
    MiniDiffOverChangeBuf.bg = blend base0B base00 0.2;
  };
  vim.keymaps = [
    (lib.nvim.binds.mkKeymap ["n"] ''\o'' ''require("mini.diff").toggle_overlay'' {
      desc = "toggle diff overlay";
      lua = true;
    })
  ];
}
