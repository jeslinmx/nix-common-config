_: {
  services = {
    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 7;
      percentageAction = 3;
    };
    power-profiles-daemon.enable = true;
    logind = {
      powerKey = "hibernate";
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
    };
  };
}
