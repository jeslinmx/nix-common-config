{nvfModules, ...}: {
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues (removeAttrs nvfModules ["default"]);
  vim = {
    viAlias = true;
    vimAlias = true;
    languages = {
      nix = {
        enable = true;
        lsp.servers = ["nixd"];
      };
      lua.enable = true;
      html.enable = true;
      markdown = {
        enable = true;
        lsp.servers = lib.mkForce ["markdown-oxide"];
      };
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
