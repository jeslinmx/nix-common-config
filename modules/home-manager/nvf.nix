{
  flake,
  pkgs,
  ...
}: {
  home = {
    packages = [flake.packages.${pkgs.stdenv.hostPlatform.system}.neovim-default flake.inputs.nvf.packages.${pkgs.stdenv.hostPlatform.system}.docs-manpages];
    sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
