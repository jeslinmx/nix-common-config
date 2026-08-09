{
  flake,
  lib,
  ...
}: {
  imports = builtins.attrValues {
    inherit
      (flake.darwinModules)
      stylix
      home-manager-users
      nix-config
      sudo
      sshd
      macos-tweaks
      homebrew
      rosetta-builder
      ;
  };

  config = {
    programs.fish.enable = lib.mkDefault true;
    nixpkgs.config.allowUnfree = lib.mkDefault true;
  };
}
