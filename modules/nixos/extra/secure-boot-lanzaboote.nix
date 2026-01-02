{inputs, ...}: {
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  # For secure boot to work, you must do the following steps:
  # 1. reboot into UEFI menu and set Secure Boot to Setup Mode
  # 2. boot the system
  # 3. set Secure Boot back to Deployed Mode if not automatically reverted

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
      settings = {
        timeout = 0;
        editor = false;
        auto-poweroff = true; # add an entry to shutdown the system
      };
    };
    # for TPM auto-unlocking
    # note that when the boot environment changes (e.g. UEFI firmware update, new secure boot keys enrolled),
    # the PCRs will be invalidated, and thus the TPM will stop dispensing the previously enrolled key
    # the following command must be run to regenerate a new key and wipe the old one:
    # systemd-cryptenroll <device name> --tpm2-device=auto --tpm2-pcrs=0,2,7 --wipe-slot=tpm2
    initrd.systemd = {
      enable = true;
      tpm2.enable = true;
    };
  };
  environment.systemPackages = [pkgs.sbctl];
}
