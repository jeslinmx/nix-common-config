{...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  next-wallpaper = pkgs.writeShellApplication {
    name = "next-wallpaper";
    runtimeInputs = [config.programs.caelestia-shell.cliPackage];
    text = ''
      caelestia wallpaper -r ${config.programs.caelestia-shell.settings.paths.wallpaperDir}
    '';
  };
in {
  home.packages = [next-wallpaper];
  systemd.user = {
    services.next-wallpaper = {
      Unit.Description = "Change to next wallpaper";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe next-wallpaper;
      };
    };
    timers.next-wallpaper = {
      Unit = {
        Description = "Change next wallpaper every 3 minutes";
        After = "wayland-session@Hyprland.target";
      };
      Timer.OnCalendar = "*:00/3:00";
      Install.WantedBy = ["wayland-session@Hyprland.target"];
    };
  };
}
