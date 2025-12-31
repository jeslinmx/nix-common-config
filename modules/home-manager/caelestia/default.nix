{inputs, ...}: {config, ...}: {
  imports = builtins.attrValues {
    inherit (inputs.caelestia-shell.homeManagerModules) default;
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
  wayland.windowManager.hyprland.settings.layerrule = [
    "noanim, caelestia-(launcher|osd|notifications|border-exclusion|area-picker)"
    "animation fade, caelestia-(drawers|background)"
    "order 1, caelestia-border-exclusion"
    "order 2, caelestia-bar"
    "xray 1, caelestia-(border|launcher|bar|sidebar|navbar|mediadisplay|screencorners)"
    "blur, caelestia-.*"
    "blur, qs-.*"
    "blurpopups, caelestia-.*"
    "ignorealpha 0.01, caelestia-.*"
  ];
}
