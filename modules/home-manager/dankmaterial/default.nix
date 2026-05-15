{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = builtins.attrValues {
    inherit (inputs.dank-material-shell.homeModules) dank-material-shell;
    inherit (inputs.dms-plugin-registry.homeModules) default;
  };

  options.dms = let
    inherit (lib) types mkOption;
  in {
    hassTokenPath = mkOption {
      type = types.nullOr types.externalPath;
      default = null;
    };
  };

  config = {
    programs = let
      # hotfix until https://github.com/AvengeMedia/DankMaterialShell/pull/1864 lands (v1.4.5)
      dms = lib.getExe' inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell "dms";
      # dms = lib.getExe' config.programs.dank-material-shell.package "dms";
    in {
      dank-material-shell = {
        enable = true;
        systemd.enable = true;
        settings =
          ./settings.json
          |> builtins.readFile
          |> builtins.fromJSON
          |> ({barConfigs, ...} @ settings:
            settings
            // {
              cornerRadius = config.wayland.windowManager.hyprland.settings.decoration.rounding;
              barConfigs =
                barConfigs
                |> lib.imap (i: bar:
                  bar
                  // {
                    spacing = config.wayland.windowManager.hyprland.settings.general.gaps_out;
                  }
                  // (
                    if i == 1
                    then {
                      leftWidgets =
                        bar.leftWidgets
                        ++ (map ({id, ...}: {
                            id = "dankActions:${id}";
                            enabled = true;
                          })
                          config.programs.dank-material-shell.plugins.dankActions.settings.variants);
                    }
                    else {}
                  ));
            })
          |> builtins.mapAttrs (_: lib.mkOverride 1100); # prioritize below stylix
        plugins = {
          calculator = {
            enable = true;
            settings = {calcEngine = "qalc";};
          };
          catWidget.enable = true;
          dankActions.enable = true;
          dankGifSearch.enable = true;
          dankKDEConnect.enable = true;
          dankObsidian.enable = true;
          desktopCommand.enable = true;
          discordVoice.enable = true;
          emojiLauncher.enable = true;
          githubNotifier.enable = true;
          homeAssistantMonitor = {
            enable = !isNull config.dms.hassTokenPath;
            settings = {hassTokenPath = config.dms.hassTokenPath;};
          };
          musicLyrics = {
            enable = true;
            src = lib.mkForce inputs.dms-plugin-musiclyrics;
            settings = {
              widgetMaxWidth = 180;
              showTitleWhenPaused = true;
              pillDisplayMode = "1";
            };
          };
          screenRecorder.enable = true;
          simpleAudioControl = {
            enable = true;
            settings = {
              showMic = true;
              showMicValue = true;
              volumeScrollStep = 5;
              micVolumeScrollStep = 5;
              maxVolumePercent = 200;
            };
          };
          usbManager.enable = true;
        };
      };

      bash.initExtra = "source <(${dms} completion bash)";
      fish.interactiveShellInit = lib.mkAfter "${dms} completion fish | source";
      zsh.initContent = "source <(${dms} completion zsh)";
    };

    home.packages = with pkgs; [libqalculate]; # for calculator plugin
    services.kdeconnect.enable = true;

    wayland.windowManager.hyprland.settings = {
      source = [
        "~/.config/hypr/dms/outputs.conf"
        "~/.config/hypr/dms/windowrules.conf"
      ];
      bind = [
        "SUPER, SPACE, exec, dms ipc launcher toggle"
        "SUPER, PERIOD, exec, dms ipc launcher toggleQuery \":e \""
        "SUPER, BACKSPACE, exec, dms ipc powermenu toggle"
        "SUPER, V, exec, dms ipc clipboard toggle"
        "SUPER, D, exec, dms ipc dash toggle \"\""
        "SUPER, W, exec, dms ipc notepad toggle"
        "SUPER, N, exec, dms ipc notifications toggle"
        "SUPER, X, exec, dms ipc notifications dismissAllPopups"
        "SUPER, P, exec, dms ipc color-picker toggle"
        "SUPER, R, exec, dms ipc workspace-rename toggle"
        "SUPER, A, exec, dms ipc hypr toggleOverview"
        "SHIFT SUPER, slash, exec, dms ipc keybinds toggle hyprland"
        "SUPER, C, exec, dms ipc control-center toggle"
        "SUPER, I, exec, dms ipc settings toggle"
        ", print, exec, dms screenshot full --no-file"
        "ALT, print, exec, dms screenshot window --no-file"
        "CTRL, print, exec, dms screenshot region --no-file"
        "SUPER, print, exec, dms screenshot full"
        "ALT SUPER, print, exec, dms screenshot window"
        "CTRL SUPER, print, exec, dms screenshot region"
      ];
    };
  };
}
