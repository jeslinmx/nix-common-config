_: {
  lib,
  pkgs,
  ...
}: {
  services = {
    udev = {
      packages = [pkgs.yubikey-personalization];
      extraRules = ''
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
  security.pam.u2f = {
    enable = true;
    control = "required";
    settings = lib.mkDefault {
      cue = true; # prompt user to tap authenticator
      # interactive = true; # prompt user to insert authenticator and press enter
    };
  };
}
