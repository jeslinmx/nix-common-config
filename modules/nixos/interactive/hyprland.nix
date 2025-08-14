{...}: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };
  networking.networkmanager.enable = true;
  services.logind = {
    powerKey = "hibernate";
    lidSwitchDocked = "suspend";
  };
}
