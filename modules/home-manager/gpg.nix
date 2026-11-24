{
  lib,
  pkgs,
  ...
}: {
  services.gpg-agent = {
    enable = true;
    pinentry = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      package = pkgs.pinentry_mac;
      program = "pinentry-mac";
    };
  };
}
