_: {lib, ...}: {
  services = {
    upower = {
      enable = true;
      percentageLow = 15;
      percentageCritical = 7;
      percentageAction = 3;
    };
    power-profiles-daemon.enable = true;
    logind.settings.Login = {
      HandlePowerKey = "hibernate";
      HandleLidSwitch = "suspend";
    };
    libinput = {
      enable = true;
      touchpad = lib.mkDefault {
        # middle/right mouse clicks based on number of fingers, not click region
        clickMethod = "clickfinger";
        middleEmulation = false;
        naturalScrolling = true;
        tappingButtonMap = "lrm";
      };
    };
  };
}
