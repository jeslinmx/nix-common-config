_: {
  config,
  lib,
  pkgs,
  ...
} @ args: let
  common = (import ./common.nix) args;
  inherit (common) mute-command volume-command move-monitor-command scrot-base-command terminal-command emoji-picker-command clipboard-command fileman-command;
in {
  wayland.windowManager.hyprland = let
    cfg = config.wayland.windowManager.hyprland;
  in {
    enable = true;
    sourceFirst = false; # put source statements at end
    settings = let
      directionKeys = [["up" "k"] ["down" "j"] ["left" "h"] ["right" "l"]];
      directions = ["u" "d" "l" "r"];
      produceBinds = {
        mod ? "SUPER",
        keys ? directionKeys,
        dispatcher,
        args ? directions,
      }:
        lib.concatMap (
          {
            fst,
            snd,
          }:
            lib.map
            (key: lib.concatStringsSep ", " [mod key dispatcher snd])
            (
              if lib.isList fst
              then fst
              else lib.singleton fst
            )
        ) (lib.zipLists keys args);
    in rec {
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = let
          inherit (config.lib.stylix.colors) base0C base0D;
        in
          lib.mkForce "rgba(${base0C}ff) rgba(${base0D}ff) 45deg";
        # inactive_border is set by stylix
        resize_on_border = true;
        allow_tearing = true; # master switch
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        dim_inactive = true;
        dim_strength = 0.2;
        shadow.enabled = false;
        blur = {
          enabled = false;
          size = 1;
          passes = 4;
        };
      };

      animation = [
        "global, 1, 3, default"
        "borderangle, 1, 20, default, once"
        "specialWorkspace, 1, 3, default, slidefadevert 20%"
      ];

      group = let
        inherit (config.lib.stylix.colors) base09 base0A base0D;
      in {
        # not yet available in 0.44.1
        # drag_into_group = 2; # only drag into group via groupbar
        "col.border_active" = lib.mkForce cfg.settings.general."col.active_border";
        # border_inactive is set by stylix
        "col.border_locked_active" = lib.mkForce "rgba(${base0A}ff) rgba(${base09}ff) 45deg";
        "col.border_locked_inactive" = cfg.settings.general."col.inactive_border";
        groupbar = {
          "col.active" = "rgb(${base0D})";
          "col.inactive" = cfg.settings.group."col.border_inactive";
          "col.locked_active" = "rgba(${base0A}ff)";
          "col.locked_inactive" = cfg.settings.group."col.border_locked_inactive";
        };
      };

      dwindle = {
        pseudotile = true; # master switch
        smart_split = true;
      };

      misc = {
        disable_hyprland_logo = true; # disable default wallpapers
        middle_click_paste = false;
        new_window_takes_over_fullscreen = 2; # kick out of fullscreen if opening new window
      };

      input.touchpad.natural_scroll = true;
      gesture = [
        "3, horizontal, workspace"
        "3, pinch, special, magic"
        "4, up, fullscreen"
        "4, down, float"
      ];
      gestures = {
        workspace_swipe_cancel_ratio = 0.2;
        workspace_swipe_direction_lock = false;
      };

      monitor = [
        "eDP-1,preferred,0x0,1"
        ",preferred,auto,auto"
      ];

      exec-once = [
        "systemctl --user start hyprpolkitagent"
        "uwsm app -- fcitx5 -d -r &"
        "uwsm finalize"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      windowrulev2 = let
        rule = dispatchers: conditions: lib.map (d: "${d}, ${conditions}") dispatchers;
      in
        [
          "suppressevent maximize, class:.*"
          "float, class:(org.telegram.desktop) title:(Media viewer)"
          "workspace special:magic, class:(org.telegram.desktop)"
          "workspace special:magic, class:(teams-for-linux)"
          "opacity 1.0 0.2, floating:1"
        ]
        ++ (
          rule
          ["float" "pin" "keepaspectratio" "opacity 1.0 1.0" "noinitialfocus" "size 25% 25%" "move 100%-w-${builtins.toString (general.gaps_out + general.border_size)} 100%-w-${builtins.toString (general.gaps_out + general.border_size)}"]
          "class:(firefox), title:(Picture-in-Picture)"
        );

      ### BINDS ###

      bind =
        [
          "SUPER, RETURN, togglesplit"
          "SUPER, F11, fullscreen, 1"
          "SUPER, Q, killactive"
          "SUPER, F, togglefloating"
          "SUPER, F, centerwindow"
          "SUPER, P, pseudo" # dwindle
          "SUPER, G, togglegroup"
          "CTRL SUPER, G, lockactivegroup, toggle"
          "SUPER, S, togglespecialworkspace, magic"
          "SUPER, escape, exec, loginctl lock-session"
          "SUPER, delete, global, caelestia:session"
          "SUPER, SPACE, global, caelestia:launcher"
          "SUPER, PERIOD, exec, ${emoji-picker-command}"
          "SUPER, V, exec, ${clipboard-command}"
          "SUPER, T, exec, ${terminal-command}"
          "SUPER, E, exec, ${fileman-command}"
          "SUPER, C, global, caelestia:clearNotifs"
        ]
        # switch focus with SUPER + direction
        ++ (produceBinds {dispatcher = "movefocus";})
        # move windows with SHIFT + SUPER + direction
        ++ (produceBinds {
          mod = "SHIFT SUPER";
          dispatcher = "movewindow";
        })
        # swap windows with CTRL + SHIFT + SUPER + direction
        ++ (produceBinds {
          mod = "CTRL SHIFT SUPER";
          dispatcher = "swapwindow";
        })
        # move window into groups with CTRL + SUPER + direction
        ++ (produceBinds {
          mod = "CTRL SUPER";
          dispatcher = "movewindoworgroup";
        })
        # move displays with CTRL + SHIFT + ALT + SUPER + direction
        ++ (produceBinds {
          mod = "CTRL SHIFT ALT SUPER";
          dispatcher = "exec";
          args = builtins.map (x: move-monitor-command (builtins.elemAt x 0)) directionKeys;
        })
        # switch workspaces with SUPER + number
        ++ (produceBinds {
          keys = lib.map builtins.toString (lib.range 1 9) ++ ["0"];
          dispatcher = "workspace";
          args = lib.map builtins.toString (lib.range 1 10);
        })
        # switch workspaces to current display with CTRL + SUPER + number
        ++ (produceBinds {
          mod = "CTRL SUPER";
          keys = lib.map builtins.toString (lib.range 1 9) ++ ["0"];
          dispatcher = "focusworkspaceoncurrentmonitor";
          args = lib.map builtins.toString (lib.range 1 10);
        })
        # move window to workspaces with SHIFT + SUPER + number/S
        ++ (produceBinds {
          mod = "SHIFT SUPER";
          keys = lib.map builtins.toString (lib.range 1 9) ++ ["0" "S"];
          dispatcher = "movetoworkspace";
          args = lib.map builtins.toString (lib.range 1 10) ++ ["special:magic"];
        })
        # silently move window to workspaces with CTRL + SHIFT + SUPER + number/S
        ++ (produceBinds {
          mod = "CTRL SHIFT SUPER";
          keys = lib.map builtins.toString (lib.range 1 9) ++ ["0" "S"];
          dispatcher = "movetoworkspacesilent";
          args = lib.map builtins.toString (lib.range 1 10) ++ ["special:magic"];
        })
        ++ [
          ", print, exec, ${scrot-base-command} --clipboard-only --mode output"
          "ALT, print, exec, ${scrot-base-command} --clipboard-only --mode window"
          "CTRL, print, exec, ${scrot-base-command} --clipboard-only --mode region"
          "SUPER, print, exec, ${scrot-base-command} --mode output"
          "ALT SUPER, print, exec, ${scrot-base-command} --mode window"
          "CTRL SUPER, print, exec, ${scrot-base-command} --mode region"
        ];

      bindl =
        [
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioMute, exec, ${mute-command "@DEFAULT_AUDIO_SINK@"}"
          "ALT, XF86AudioMute, exec, ${mute-command "@DEFAULT_AUDIO_SOURCE@"}"
          ", XF86AudioMicMute, exec, ${mute-command "@DEFAULT_AUDIO_SOURCE@"}"
        ]
        # brightness keys
        ++ [
          ",XF86MonBrightnessUp,   global, caelestia:brightnessUp"
          ",XF86MonBrightnessDown, global, caelestia:brightnessDown"
        ];

      binde =
        [
          # Switch within groups with CTRL + [SHIFT] + SUPER + tab
          "CTRL SUPER, tab, changegroupactive, f"
          "CTRL SHIFT SUPER, tab, changegroupactive, b"
        ]
        # resize windows with ALT + SUPER + direction
        ++ (produceBinds {
          mod = "ALT SUPER";
          dispatcher = "resizeactive";
          args = let dist = "25"; in ["0 -${dist}" "0 ${dist}" "-${dist} 0" "${dist} 0"];
        })
        # fine resize windows with CTRL + ALT + SUPER + direction
        ++ (produceBinds {
          mod = "CTRL ALT SUPER";
          dispatcher = "resizeactive";
          args = let dist = "1"; in ["0 -${dist}" "0 ${dist}" "-${dist} 0" "${dist} 0"];
        });
      # volume keys; use ALT to target mic, use CTRL for fine adjustment
      bindel =
        lib.concatMap ({
          mod,
          dev,
          amt,
        }: [
          "${mod}, XF86AudioRaiseVolume, exec, ${volume-command dev amt}"
          "${mod}, XF86AudioLowerVolume, exec, ${volume-command dev (-amt)}"
        ]) [
          {
            mod = "";
            dev = "@DEFAULT_AUDIO_SINK@";
            amt = 5;
          }
          {
            mod = "CTRL";
            dev = "@DEFAULT_AUDIO_SINK@";
            amt = 1;
          }
          {
            mod = "ALT";
            dev = "@DEFAULT_AUDIO_SOURCE@";
            amt = 5;
          }
          {
            mod = "CTRL ALT";
            dev = "@DEFAULT_AUDIO_SOURCE@";
            amt = 1;
          }
        ];

      bindm = [
        "SUPER, z, movewindow"
        "SUPER ALT, z, resizewindow"
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };

  home.file.".config/hypr/shaders".source = ./shaders;
  home.packages = [pkgs.hyprpolkitagent];
}
