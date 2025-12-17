{
  inputs,
  nvfModules,
  ...
}: {...}: {
  imports = [inputs.nvf.homeManagerModules.default];
  programs.nvf = {
    enableManpages = true;
    defaultEditor = true;
    settings = nvfModules.default;
  };
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
