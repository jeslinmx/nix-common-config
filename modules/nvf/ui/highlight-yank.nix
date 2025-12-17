_: {
  config,
  lib,
  ...
}: {
  vim = let
    augroup = "highlightyank";
  in {
    augroups = [{name = augroup;}];
    autocmds = [
      {
        desc = "Highlight on yank";
        event = ["TextYankPost"];
        pattern = ["*"];
        group = augroup;
        callback = lib.generators.mkLuaInline ''
           function()
            vim.highlight.on_yank { higroup = "YankedText", timeout = 150 }
          end
        '';
      }
    ];
    highlight.YankedText = let
      inherit (config.vim.theme.base16-colors) base00 base0F;
    in {
      fg = base00;
      bg = base0F;
    };
  };
}
