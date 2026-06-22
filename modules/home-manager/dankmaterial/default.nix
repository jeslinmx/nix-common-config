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
              cornerRadius = config.wayland.windowManager.hyprland.settings.config.decoration.rounding;
              barConfigs =
                barConfigs
                |> lib.imap (i: bar:
                  bar
                  // {
                    spacing = config.wayland.windowManager.hyprland.settings.config.general.gaps_out;
                  }
                  // (
                    if i == 1
                    then {
                      rightWidgets =
                        (map ({id, ...}: {
                            id = "dankActions:${id}";
                            enabled = true;
                          })
                          config.programs.dank-material-shell.plugins.dankActions.settings.variants)
                        ++ bar.rightWidgets;
                    }
                    else {}
                  ));
            })
          |> builtins.mapAttrs (_: lib.mkOverride 1100); # prioritize below stylix
        clipboardSettings = {
          disabled = false;
          disableHistory = false;
          disablePersist = true;
          maxHistory = 100;
          autoClearDays = 30;
          clearAtStartup = false;
        };
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

    wayland.windowManager.hyprland = {
      extraConfig = ''
        require("dms/outputs")
        require("dms/windowrules")
      '';
      settings = {
        bind =
          [
            {
              mod = ["SUPER"];
              binds = {
                SPACE = "ipc launcher toggle";
                PERIOD = ''ipc launcher toggleQuery \":e \"'';
                BACKSPACE = "ipc powermenu toggle";
                V = "ipc clipboard toggle";
                D = ''ipc dash toggle \"\"'';
                W = "ipc notepad toggle";
                N = "ipc notifications toggle";
                X = "ipc notifications dismissAllPopups";
                R = "ipc workspace-rename toggle";
                A = "ipc hypr toggleOverview";
                C = "ipc control-center toggle";
                I = "ipc settings toggle";
                "SHIFT + SLASH" = "ipc keybinds toggle hyprland";
              };
            }
            {
              mod = [];
              binds = {
                "PRINT" = "screenshot full --no-file";
                "ALT + PRINT" = "screenshot window --no-file";
                "CTRL + PRINT" = "screenshot region --no-file";
                "SUPER + PRINT" = "screenshot full";
                "ALT + SUPER + PRINT" = "screenshot window";
                "CTRL + SUPER + PRINT" = "screenshot region";
              };
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
                  (lib.generators.mkLuaInline ''hl.dsp.exec_raw("dms ${dsp}")'')
                  flags
                ];
              })
              |> builtins.attrValues
          );
      };
    };
  };
}
