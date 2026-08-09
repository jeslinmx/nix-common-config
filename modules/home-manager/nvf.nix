{flake, ...}: {
  imports = [flake.inputs.nvf.homeManagerModules.default];
  programs.nvf = {
    enableManpages = true;
    defaultEditor = true;
    settings = flake.nvfModules.default;
  };
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
