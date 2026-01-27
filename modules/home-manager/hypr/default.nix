{homeModules, ...}: {...}: {
  imports = builtins.attrValues {
    inherit
      (homeModules)
      hypr-hyprland
      hypr-hypridle
      hypr-wallpaper-cycle
      caelestia
      ;
  };

  services = {
    ssh-agent.enable = true;
    polkit-gnome.enable = true;
    cliphist.enable = true;
    mpris-proxy.enable = true;
  };
  systemd.user.services.caelestia.Service.Environment = ["QT_QPA_PLATFORMTHEME=gtk3"];

  systemd.user.services = {
    ssh-agent = {
      Unit.Before = ["graphical-session-pre.target"];
      Service = {
        ExecStartPost = "systemctl --user set-environment \"SSH_AUTH_SOCK=%t/ssh-agent\"";
        ExecStopPost = "systemctl --user unset-environment SSH_AUTH_SOCK";
      };
    };
  };
}
