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

  config = lib.mkOverride 900 {
    programs.fish.enable = true;
  };
}
