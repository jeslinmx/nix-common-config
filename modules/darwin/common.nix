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
      # aerospace
      homebrew
      rosetta-builder
      ;
  };

  config = lib.mkOverride 900 {
    nixpkgs.hostPlatform = "aarch64-darwin";
    programs.fish.enable = true;
  };
}
