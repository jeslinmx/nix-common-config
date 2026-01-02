_: {pkgs, ...}: let
  netboot = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    inherit (pkgs.stdenv.hostPlatform) system;
    modules = [
      (pkgs.path + "/nixos/modules/installer/netboot/netboot-minimal.nix")
    ];
  };
in {
  boot.loader.limine.extraEntries = ''
    /NixOS rescue image
      comment: ${netboot.config.system.nixos.distroName} ${netboot.config.system.nixos.version} ()
      protocol: linux
      kernel_path: boot():/limine/rescue-kernel
      kernel_cmdline: init=${netboot.config.system.build.toplevel}/init ${toString netboot.config.boot.kernelParams}
      module_path: boot():/limine/rescue-initrd
    }
  '';
  boot.loader.limine.additionalFiles = {
    "rescue-kernel" = "${netboot.config.system.build.kernel}/bzImage";
    "rescue-initrd" = "${netboot.config.system.build.netbootRamdisk}/initrd";
  };
}
