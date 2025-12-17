{inputs, ...}: {
  lib,
  pkgs,
  ...
}: {
  vim.theme = {
    enable = true;
    name = "base16";
    base16-colors = let
      schemeName = "catppuccin-mocha";
      schemaFile = "${inputs.tt-schemes.outPath}/base16/${schemeName}.yaml";
      schemeAttrs = (pkgs.callPackage inputs.stylix.inputs.base16.lib {}).mkSchemeAttrs schemaFile;
    in
      lib.mkDefault {inherit (schemeAttrs.withHashtag) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;};
  };
}
