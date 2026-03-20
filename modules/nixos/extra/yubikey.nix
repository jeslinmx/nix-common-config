{nixosModules, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [nixosModules.hotfix-486044-pam_u2f];
  options.security.yubikey.lockOnRemoval = lib.mkEnableOption "automatic locking of session on Yubikey removal";
  config = {
    services = {
      udev = {
        packages = [pkgs.yubikey-personalization];
        extraRules = lib.mkIf config.security.yubikey.lockOnRemoval ''
          ACTION=="remove",\
          ENV{ID_BUS}=="usb",\
          ENV{ID_MODEL_ID}=="0407",\
          ENV{ID_VENDOR_ID}=="1050",\
          ENV{ID_VENDOR}=="Yubico",\
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
      };
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    security.pam = {
      u2f = {
        enable = true;
        control = "required";
        settings = lib.mkDefault {
          cue = true; # prompt user to tap authenticator
          # interactive = true; # prompt user to insert authenticator and press enter
        };
      };
      services = {
        sudo.nodelay = true;
        login.nodelay = true;
        greetd.nodelay = true;
      };
    };
  };
}
