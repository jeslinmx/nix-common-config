_: {
  lib,
  pkgs,
  ...
}: {
  boot.loader = {
    grub.enable = false;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      netbootxyz.enable = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.netbootxyz-efi;
      memtest86.enable = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.memtest86plus;
    };
  };
}
