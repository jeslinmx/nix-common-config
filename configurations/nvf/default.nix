{flake, ...}: {
  imports = builtins.attrValues flake.nvfModules;
  vim = {
    viAlias = true;
    vimAlias = true;
  };
}
