_: {
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = let
    cfg = config.wayland.windowManager.hyprland;
  in {
    enable = true;
    sourceFirst = false; # put source statements at end
    configType = "lua";
    settings = {
      config = {
        general = {
          border_size = 2;
          gaps_in = 4;
          gaps_out = 8;
          float_gaps = -1;
          "col.active_border" = let
            inherit (config.lib.stylix.colors) base0C base0D;
          in
            lib.mkForce {
              colors = ["rgba(${base0C}ff)" "rgba(${base0D}ff)"];
              angle = 45;
            };
          # inactive_border is set by stylix
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true; # master switch
        };
        decoration = {
          rounding = 10;
          dim_inactive = true;
          dim_strength = 0.2;
          dim_special = 0.5;
          blur = {
            size = 8;
            passes = 2;
          };
          shadow.enabled = false;
        };
        input = {
          focus_on_close = 1; # shift focus to window under cursor when window closed
          touchpad = {
            disable_while_typing = true;
            natural_scroll = true;
            clickfinger_behavior = true; # middle/right mouse clicks based on number of fingers, not click region
            tap_to_click = true;
            drag_lock = 2; # sticky draglock
            tap_and_drag = true;
          };
        };
        gestures = {
          workspace_swipe_min_speed_to_force = 25;
          workspace_swipe_cancel_ratio = 0.2;
          workspace_swipe_direction_lock = false;
        };
        group = let
          inherit (config.lib.stylix.colors) base09 base0A base0D;
        in {
          auto_group = false;
          drag_into_group = 2; # only drag into group via groupbar
          merge_groups_on_drag = false;
          merge_groups_on_groupbar = true;
          merge_floated_into_tiled_on_groupbar = true;
          "col.border_active" = lib.mkForce cfg.settings.config.general."col.active_border";
          # border_inactive is set by stylix
          "col.border_locked_active" = lib.mkForce {
            colors = ["rgba(${base0A}ff)" "rgba(${base09}ff)"];
            angle = 45;
          };
          "col.border_locked_inactive" = cfg.settings.config.general."col.inactive_border";
          groupbar = {
            font_size = 10;
            indicator_height = 2;
            "col.active" = "rgb(${base0D})";
            "col.inactive" = cfg.settings.config.group."col.border_inactive";
            "col.locked_active" = "rgba(${base0A}ff)";
            "col.locked_inactive" = cfg.settings.config.group."col.border_locked_inactive";
          };
        };
        misc = {
          disable_hyprland_logo = true; # disable default wallpapers
          middle_click_paste = false;
        };
        binds = {
          hide_special_on_workspace_change = true;
        };
        xwayland = {
          force_zero_scaling = true;
        };
        cursor = {
          persistent_warps = true; # cursor moves to last position in window when changing focus, instead of center
          warp_on_change_workspace = 1; # focus cursor on last active window when changing workspace
          warp_on_toggle_special = 1;
        };
        ecosystem = {
          no_donation_nag = true;
        };
        dwindle = {
          # smart_split = true; # split by cursor position rather than aspect ratio and allow manual changing
        };
      };
      monitor = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "0x0";
          scale = 1;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];
      bind = let
        directions = {
          Left = "l";
          Right = "r";
          Up = "u";
          Down = "d";
          H = "l";
          J = "d";
          K = "u";
          L = "r";
        };
        numbers = (lib.range 1 9 |> map toString |> map (x: lib.nameValuePair x x) |> builtins.listToAttrs) // {"0" = "10";};
      in
        [
          {
            mod = "SUPER";
            binds = {
              Return = ''layout("togglesplit")'';
              F11 = ''window.fullscreen("maximized")'';
              Q = ''window.close()'';
              F = ''window.float()'';
              G = ''group.toggle()'';
              S = ''workspace.toggle_special("magic")'';
              T = ''exec_raw("xdg-terminal-exec")'';
              Escape = ''exec_raw("loginctl lock-session")'';
              # toggle_swallow
              # pin
            };
          }
          {
            # switch focus with SUPER + direction
            mod = "SUPER";
            binds = directions |> builtins.mapAttrs (_: direction: ''focus({ direction = "${direction}" })'');
            flags.repeating = true;
          }
          {
            # swap windows with SHIFT + SUPER + direction
            mod = ["SHIFT" "SUPER"];
            binds = directions |> builtins.mapAttrs (_: direction: ''window.swap({ direction = "${direction}" })'');
            flags.repeating = true;
          }
          {
            # move windows with CTRL + SUPER + direction
            mod = ["CTRL" "SUPER"];
            binds = directions |> builtins.mapAttrs (_: direction: ''window.move({ direction = "${direction}" })'');
            flags.repeating = true;
          }
          {
            # move window into groups with CTRL + SHIFT + SUPER + direction
            mod = ["CTRL" "SHIFT" "SUPER"];
            binds = directions |> builtins.mapAttrs (_: direction: ''window.move({ direction = "${direction}", group_aware = true })'');
            flags.repeating = true;
          }
          {
            # switch within groups with CTRL + [SHIFT] + SUPER + tab
            mod = ["CTRL" "SUPER"];
            binds = {
              "TAB" = ''group.next()'';
              "SHIFT + TAB" = ''group.prev()'';
            };
            flags.repeating = true;
          }
          {
            # switch workspaces to current display with SUPER + number
            mod = "SUPER";
            binds = numbers |> builtins.mapAttrs (_: number: ''focus({ workspace = ${number}, on_current_monitor = true })'');
          }
          {
            # move window to workspaces with SHIFT + SUPER + number/S
            mod = ["SHIFT" "SUPER"];
            binds = (numbers // {S = ''"special:magic"'';}) |> builtins.mapAttrs (_: number: ''window.move({ workspace = ${number}, follow = false })'');
            flags.repeating = true;
          }
          # media keys
          {
            binds = let
              playerctl = lib.getExe pkgs.playerctl;
              wpctl = lib.getExe' pkgs.wireplumber "wpctl";
            in {
              "XF86AudioPlay" = ''exec_raw("${playerctl} play-pause")'';
              "XF86AudioPrev" = ''exec_raw("${playerctl} previous")'';
              "XF86AudioNext" = ''exec_raw("${playerctl} next")'';
              "XF86AudioMute" = ''exec_raw("${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle")'';
              "XF86AudioMicMute" = ''exec_raw("${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'';
              "ALT + XF86AudioMute" = ''exec_raw("${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'';
            };
            flags.locked = true;
          }
          # brightness and volume keys
          {
            binds = let
              brightnessctl = lib.getExe pkgs.brightnessctl;
              wpctl = lib.getExe' pkgs.wireplumber "wpctl";
            in {
              "XF86MonBrightnessUp" = ''exec_raw("${brightnessctl} set 5%+")'';
              "XF86MonBrightnessDown" = ''exec_raw("${brightnessctl} set 5%-")'';
              "CTRL + XF86MonBrightnessUp" = ''exec_raw("${brightnessctl} set 1%+")'';
              "CTRL + XF86MonBrightnessDown" = ''exec_raw("${brightnessctl} set 1%-")'';
              "XF86AudioRaiseVolume" = ''exec_cmd("${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0")'';
              "XF86AudioLowerVolume" = ''exec_raw("${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-")'';
              "CTRL + XF86AudioRaiseVolume" = ''exec_cmd("${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+ && ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0")'';
              "CTRL + XF86AudioLowerVolume" = ''exec_raw("${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-")'';
              "ALT + XF86AudioRaiseVolume" = ''exec_cmd("${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 5%+ && ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 0")'';
              "ALT + XF86AudioLowerVolume" = ''exec_raw("${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 5%-")'';
              "CTRL + ALT + XF86AudioRaiseVolume" = ''exec_cmd("${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 1%+ && ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 0")'';
              "CTRL + ALT + XF86AudioLowerVolume" = ''exec_raw("${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 1%-")'';
            };
            flags = {
              locked = true;
              repeating = true;
            };
          }
          {
            mod = "SUPER";
            binds = {
              "Z" = ''window.drag()'';
              "ALT + Z" = ''window.resize()'';
              "mouse:272" = ''window.drag()'';
              "mouse:273" = ''window.resize()'';
            };
            flags.mouse = true;
          }
          {
            mod = ["ALT" "SUPER"];
            binds = {
              H = ''window.resize({ x = -5, y =  0, relative = true })'';
              J = ''window.resize({ x =  0, y = -5, relative = true })'';
              K = ''window.resize({ x =  0, y =  5, relative = true })'';
              L = ''window.resize({ x =  5, y =  0, relative = true })'';
            };
            flags.repeating = true;
          }
        ]
        |> builtins.concatMap (
          {
            mod ? [],
            binds,
            flags ? {},
          }:
            binds
            |> builtins.mapAttrs (key: dsp: {
              _args = [
                ([mod key] |> lib.flatten |> map (lib.splitString " + ") |> lib.flatten |> builtins.concatStringsSep " + ")
                (lib.generators.mkLuaInline ''hl.dsp.${dsp}'')
                flags
              ];
            })
            |> builtins.attrValues
        );
      window_rule = [
        {
          match = {
            class = ''org\.telegram\.desktop'';
            title = "Media viewer";
          };
          float = true;
          content = "photo";
        }
        {
          match.class = ''org\.telegram\.desktop'';
          workspace = "special:magic";
        }
        {
          match.class = "teams-for-linux";
          workspace = "special:magic";
        }
        {
          match.class = "1password";
          workspace = "special:magic";
        }
        {
          match.class = ''(com\.slack\.)?(s|S)lack'';
          workspace = "special:magic";
        }
        {
          match.float = true;
          opacity = "1.0 0.2";
          no_blur = true;
        }
        {
          match = {
            class = "firefox";
            title = "Picture-in-Picture";
          };
          float = true;
          pin = true;
          keep_aspect_ratio = true;
          no_initial_focus = true;
          persistent_size = true;
          opaque = true;
          size = ["monitor_w * 0.25" "monitor_h * 0.25"];
          move = [
            "monitor_w - window_w - ${toString (cfg.settings.config.general.gaps_out + cfg.settings.config.general.border_size)}"
            "monitor_h - window_h - ${toString (cfg.settings.config.general.gaps_out + cfg.settings.config.general.border_size)}"
          ];
        }
        {
          match = {
            float = false;
            workspace = "f[1]";
          };
          border_size = 0;
          rounding = 0;
        }
      ];
      workspace_rule = [
        {
          workspace = "f[1]";
          gaps_out = 0;
          gaps_in = 0;
        }
      ];
      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 3;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 20;
          bezier = "default";
          style = "once";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 3;
          bezier = "default";
          style = "slidefade 30%";
        }
        {
          leaf = "specialWorkspace";
          enabled = true;
          speed = 3;
          bezier = "default";
          style = "slidefadevert 10%";
        }
      ];
      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          action = "scroll_move";
        }
        {
          fingers = 3;
          direction = "up";
          action = "float";
          mode = "float";
        }
        {
          fingers = 3;
          direction = "down";
          action = "float";
          mode = "tile";
        }
        {
          fingers = 3;
          direction = "pinch";
          action = "cursor_zoom";
          mode = "live";
        }
        {
          fingers = 4;
          direction = "horizontal";
          action = "workspace";
        }
        {
          fingers = 4;
          direction = "pinch";
          action = "special";
          workspace_name = "magic";
        }
      ];
      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("uwsm app -- fcitx5 -d -r &")
                hl.exec_cmd("uwsm finalize")
              end
            '')
          ];
        }
      ];
      env = [
        {_args = ["XCURSOR_SIZE" "24"];}
        {_args = ["HYPRCURSOR_SIZE" "24"];}
      ];
    };
  };

  home.file.".config/hypr/shaders".source = ./shaders;
}
