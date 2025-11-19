_: {pkgs, ...}: {
  home.packages = with pkgs; [_1password-cli _1password-gui];
  services.gnome-keyring.enable = true;
}
