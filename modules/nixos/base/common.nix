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
  config = {
    system.nixos.label = lib.mkOverride 900 "${config.networking.hostName}-${toString (flake.shortRev or flake.dirtyShortRev or flake.lastModified or "(unknown rev)")}";
    nixpkgs.config.allowUnfree = lib.mkDefault true;
    hardware = lib.mkDefault {
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
      cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
    programs.fish.enable = lib.mkDefault true;
    users.defaultUserShell = lib.mkOverride 900 pkgs.fish;
    environment.shellAliases.l = lib.mkForce null; # get rid of this alias
  };
}
