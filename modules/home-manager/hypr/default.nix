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
    polkit-gnome.enable = true;
    cliphist.enable = true;
    mpris-proxy.enable = true;
  };
  programs.caelestia = {
    enable = true;
    settings = let
      set = value: x: builtins.listToAttrs (builtins.map (name: {inherit name value;}) x);
      barEnable = builtins.map (x: {
        id = x;
        enabled = true;
      });
    in {
      appearance = {
        anim.durations.scale = 0.5;
        font.family = {
          mono = "Recursive Mono Linear Static";
          sans = "Recursive Sans Linear Static";
        };
        transparency = {
          enabled = true;
          base = 0.95;
        };
      };
      general = {
        apps = {
          terminal = ["ghostty"];
          explorer = ["io.elementary.files"];
        };
      };
      background = set {enabled = true;} ["desktopClock" "visualiser"];
      border = let
        inherit (config.wayland.windowManager.hyprland) settings;
        inherit (settings.general) gaps_in gaps_out;
        inherit (settings.decoration) rounding;
      in {
        thickness = gaps_out - gaps_in;
        rounding = rounding + (gaps_out - gaps_in);
      };
      bar = {
        entries = barEnable ["workspaces" "spacer" "activeWindow" "spacer" "tray" "statusIcons" "clock"];
        popouts = {activeWindow = false;};
        workspaces = {
          activeTrail = true;
          activeLabel = " ";
          occupiedBg = true;
          occupiedLabel = "󰪥 ";
          label = " ";
          specialWorkspaceIcons = [
            {
              name = "magic";
              icon = "wand_shine";
            }
          ];
        };
        status = set true ["showAudio" "showBattery" "showBluetooth" "showMicrophone" "showLockStatus"];
        clock.showIcon = false;
      };
      launcher = {
        actionPrefix = "/";
        enableDangerousActions = true;
        vimKeybinds = true;
      };
      notifs = {
        actionOnClick = true;
        defaultExpireTimeout = 30000;
      };
      utilities = {
        toasts = set true ["audioInputChanged" "audioOutputChanged" "chargingChanged" "configLoaded" "dndChanged" "gameModeChanged" "vpnChanged"];
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
