_: {...}: {
  vim.visuals.rainbow-delimiters = {
    enable = true;
    setupOpts = {
      strategy = {"" = "rainbow-delimiters.strategy.global";};
    };
  };
}
