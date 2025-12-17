_: {config, ...}: {
  vim.visuals.rainbow-delimiters = {
    enable = true;
    setupOpts = {
      strategy = {"" = "rainbow-delimiters.strategy.global";};
    };
  };
  vim.highlight = let
    inherit (config.vim.theme.base16-colors) base08 base09 base0A base0B base0C base0D base0E;
  in {
    RainbowDelimiterRed   .fg = base08;
    RainbowDelimiterYellow.fg = base0A;
    RainbowDelimiterBlue  .fg = base0D;
    RainbowDelimiterOrange.fg = base09;
    RainbowDelimiterGreen .fg = base0B;
    RainbowDelimiterViolet.fg = base0E;
    RainbowDelimiterCyan  .fg = base0C;
  };
}
