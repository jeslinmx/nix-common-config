{
  homeModules,
  inputs,
  ...
}: {config, ...}: {
  imports = builtins.attrValues {
    inherit (inputs.caelestia-shell.homeManagerModules) default;
    inherit (homeModules) caelestia-hypridle caelestia-wallpaper-cycle;
  };
  programs.caelestia = {
    enable = true;
    settings = let
      set = value: x: builtins.listToAttrs (map (name: {inherit name value;}) x);
      barEnable = map (x: {
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
          base = 0.1;
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

  # additional setup
  systemd.user.services.caelestia.Service.Environment = ["QT_QPA_PLATFORMTHEME=gtk3"];
  services = {
    ssh-agent.enable = true;
    polkit-gnome.enable = true;
    cliphist.enable = true;
    mpris-proxy.enable = true;
  };

  systemd.user.services = {
    ssh-agent = {
      Unit.Before = ["graphical-session-pre.target"];
      Service = {
        ExecStartPost = "systemctl --user set-environment \"SSH_AUTH_SOCK=%t/ssh-agent\"";
        ExecStopPost = "systemctl --user unset-environment SSH_AUTH_SOCK";
      };
    };
  };

  # Hyprland tweaks
  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER, delete, global, caelestia:session"
      "SUPER, PERIOD, exec, caelestia emoji -p"
      "SUPER, V, exec, caelestia clipboard"
      "SUPER, SPACE, global, caelestia:launcher"
      "SUPER, C, global, caelestia:clearNotifs"
      "SUPER, D, global, caelestia:dashboard"
      "SUPER, BACKSPACE, global, caelestia:session"
      ", print, global, caelestia:screenshotFreezeClip"
      "CTRL, print, global, caelestia:screenshotClip"
      "SUPER, print, global, caelestia:screenshotFreeze"
      "CTRL SUPER, print, global, caelestia:screenshot"
    ];
    layerrule = [
      "no_anim on, match:namespace caelestia-(launcher|osd|notifications|border-exclusion|area-picker)"
      "animation fade, match:namespace caelestia-(drawers|background)"
      "order 1, match:namespace caelestia-border-exclusion"
      "order 2, match:namespace caelestia-bar"
      "xray 1, match:namespace caelestia-(border|launcher|bar|sidebar|navbar|mediadisplay|screencorners)"
      "blur on, match:namespace caelestia-.*"
      "blur on, match:namespace qs-.*"
      "blur_popups on, match:namespace caelestia-.*"
      "ignore_alpha 0.01, match:namespace caelestia-.*"
    ];
  };
}
