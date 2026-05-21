{darwinModules, ...}: {lib, ...}: {
  imports = builtins.attrValues {
    inherit
      (darwinModules)
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
