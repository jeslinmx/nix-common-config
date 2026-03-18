_: {...}: {
  vim = {
    languages.enableFormat = true;
    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        default_format_opts = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
        # deno fmt defaults to --prose-wrap always, which hard-wraps markdown lines at 80 cols
        formatters.deno_fmt.append_args = ["--prose-wrap" "preserve"];
      };
    };
  };
}
