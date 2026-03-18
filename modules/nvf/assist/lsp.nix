_: {
  lib,
  pkgs,
  ...
}: {
  vim = {
    lsp = {
      enable = true;
      inlayHints.enable = true;
      lightbulb.enable = true;
      formatOnSave = true;
    };
    languages = {
      enableExtraDiagnostics = true;
      nix.enable = true;
      nix.lsp.servers = ["nixd"];
      lua.enable = true;
      html.enable = true;
      markdown.enable = true;
      markdown.lsp.servers = lib.mkForce ["markdown-oxide"];
      css.enable = true;
      ts.enable = true;
      json.enable = true;
      yaml.enable = true;
      typst.enable = true;
      python.enable = true;
    };
    treesitter.grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.latex];
  };
}
