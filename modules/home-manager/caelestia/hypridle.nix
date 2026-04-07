_: _: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "caelestia shell lock lock";
        before_sleep_cmd = "caelestia shell lock lock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 315;
          on-timeout = "caelestia shell lock lock";
        }
      ];
    };
  };
}
