_: {config, ...}: {
  security.polkit.enable = true;
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = builtins.attrNames config.home-manager.users;
    };
  };
  services.gnome.gnome-keyring.enable = true;
}
