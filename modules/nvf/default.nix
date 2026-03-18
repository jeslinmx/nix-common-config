{nvfModules, ...}: {...}: {
  imports = builtins.attrValues (removeAttrs nvfModules ["default"]);
  vim = {
    viAlias = true;
    vimAlias = true;
  };
}
