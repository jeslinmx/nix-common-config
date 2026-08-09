{flake, ...}: {
  imports = builtins.attrValues (removeAttrs flake.nvfModules ["default"]);
  vim = {
    viAlias = true;
    vimAlias = true;
  };
}
