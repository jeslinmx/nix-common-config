_: {lib, ...}: {
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
            vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
          end
        '';
      }
    ];
  };
}
