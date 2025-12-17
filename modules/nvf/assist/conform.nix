_: {...}: {
  vim = {
    languages.enableFormat = true;
    formatter.conform-nvim = {
      enable = true;
      setupOpts.default_format_opts = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
    };
  };
}
