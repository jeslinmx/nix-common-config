_: {config, ...}: {
  vim.highlight = let
    inherit (config.vim.theme.base16-colors) base02 base03 base04 base08 base0B base0C base0D base0E;
  in {
    # make line number column less obvious
    LineNr.fg = base03;
    SignColumn.link = "LineNr";

    # make window separators less obvious
    WinSeparator.fg = base02;
    FloatBorder.link = "WinSeparator";

    # remove folded section background
    Folded.fg = base04;

    # syntax highlighting tweaks
    Comment = {
      italic = true;
      fg = base03;
    };
    DiagnosticUnnecessary = {
      underdashed = true;
      sp = base03;
    };
    DiagnosticUnderlineOk = {
      underdouble = true;
      sp = base0B;
    };
    DiagnosticUnderlineHint = {
      underdotted = true;
      sp = base0C;
    };
    DiagnosticUnderlineInfo = {
      underdotted = true;
      sp = base0D;
    };
    DiagnosticUnderlineWarn = {
      underline = true;
      sp = base0E;
    };
    DiagnosticUnderlineError = {
      undercurl = true;
      sp = base08;
    };
  };
}
