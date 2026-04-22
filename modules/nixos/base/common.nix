flake @ {nixosModules, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit
      (nixosModules)
      base-home-manager-users
      base-issue-ip
      base-locale-sg
      base-nix-config
      base-power-management
      base-sshd
      base-sudo
      base-systemd-boot
      base-zswap
      ;
  };
  config = lib.mkMerge [
    (lib.mkOverride 900 {
      system.nixos.label = "${config.networking.hostName}-${toString (flake.shortRev or flake.dirtyShortRev or flake.lastModified or "(unknown rev)")}";
      nixpkgs.config.allowUnfree = true;
      hardware = {
        enableRedistributableFirmware = true;
        cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
        cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
      };
      programs.fish.enable = true;
      users.defaultUserShell = pkgs.fish;
    })
    {environment.shellAliases.l = lib.mkForce null;} # get rid of this alias
  ];
}
