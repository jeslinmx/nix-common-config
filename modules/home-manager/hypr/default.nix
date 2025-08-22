{
  homeModules,
  inputs,
  ...
}: {config, ...}: {
  imports = builtins.attrValues {
    inherit
      (homeModules)
      hypr-hyprland
      hypr-hypridle
      hypr-wallpaper-cycle
      ;
    inherit (inputs.caelestia-shell.homeManagerModules) default;
  };

  services = {
    ssh-agent.enable = true;
    cliphist.enable = true;
    mpris-proxy.enable = true;
  };
  programs.caelestia = {
    enable = true;
    settings = {
      appearance = {
        anim.durations.scale = 0.5;
        font.family = {
          mono = "Recursive Mono Linear Static";
          sans = "Recursive Sans Linear Static";
        };
      };
      general.apps = {
        terminal = ["ghostty"];
      };
      bar = {
        persistent = true;
        entries = builtins.map (x: {
          id = x;
          enabled = true;
        }) ["workspaces" "spacer" "activeWindow" "spacer" "tray" "statusIcons" "clock"];
        status = {
          showAudio = true;
        };
        workspaces = {
          activeTrail = true;
          occupiedBg = true;
          activeLabel = " ";
          occupiedLabel = "󰪥 ";
          label = " ";
        };
      };
      border = let
        inherit (config.wayland.windowManager.hyprland) settings;
        inherit (settings.general) gaps_in gaps_out;
        inherit (settings.decoration) rounding;
      in {
        thickness = gaps_out - gaps_in;
        rounding = rounding + (gaps_out - gaps_in);
      };
      launcher = {
        actionPrefix = "/";
        enableDangerousActions = true;
        vimKeybinds = true;
      };
      notifs = {
        defaultExpireTimeout = 30000;
      };
      paths = {
        mediaGif = ./monhes.gif;
        sessionGif = ./ghastling-ghast.gif;
      };
      services = {
        useTwelveHourClock = false;
      };
    };
    cli = {
      enable = true;
      settings = {
        theme = {
          enableTerm = false;
          enableHypr = false;
          enableBtop = false;
          enableGtk = false;
          enableQt = false;
        };
      };
    };
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
