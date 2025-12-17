_: {
  config,
  lib,
  ...
}: {
  vim.diagnostics = {
    enable = true;
    config = {
      signs = let
        mkConfig = attr:
          lib.generators.mkLuaInline ''
            {
              ${builtins.concatStringsSep "," (
              builtins.attrValues (
                builtins.mapAttrs (
                  n: v: "[vim.diagnostic.severity.${n}] = '${v.${attr}}'"
                )
                (lib.filterAttrs (_: v: builtins.hasAttr attr v) config.vim.diagnostics.config.signs.bySeverity)
              )
            )}
            }
          '';
      in {
        bySeverity = {
          ERROR = {
            text = "󰅚 ";
            numhl = "DiagnosticError";
            linehl = "DiagnosticERRORReverse";
          };
          WARN = {
            text = "󰀪 ";
            numhl = "DiagnosticWarn";
          };
          INFO = {
            text = "󰋽 ";
            numhl = "DiagnosticInfo";
          };
          HINT = {
            text = "󰌶 ";
            numhl = "DiagnosticHint";
          };
        };
        text = mkConfig "text";
        # overrides diff numbers
        # numhl = mkConfig "numhl";
        linehl = mkConfig "linehl";
      };
      underline = true; # underline problem area
      virtual_text = true; # embed message at end of line
      severity_sort = true; # show the symbol of the highest severity diagnostic
    };
  };
}
