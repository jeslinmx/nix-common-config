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
  programs = let
    dms = lib.getExe' config.programs.dank-material-shell.package "dms";
  in {
    dank-material-shell = {
      enable = true;
      systemd.enable = true;
      settings =
        ./settings.json
        |> builtins.readFile
        |> builtins.fromJSON
        |> builtins.mapAttrs (_: lib.mkOverride 1100); # prioritize below stylix
      managePluginSettings = true;
      plugins = {
        homeAssistantMonitor = {enable = true;};
        dankKDEConnect = {enable = true;};
        dankGifSearch = {enable = true;};
        calculator = {enable = true;};
        desktopCommand = {enable = true;};
        dockerManager = {enable = true;};
        screenRecorder = {enable = true;};
        discordVoice = {enable = true;};
        githubNotifier = {enable = true;};
        simpleAudioControl = {enable = true;};
        emojiLauncher = {enable = true;};
        ephemera = {enable = true;};
        dankObsidian = {enable = true;};
        musicLyrics = {enable = true;};
        catWidget = {enable = true;};
        dankActions = {enable = true;};
        usbManager = {enable = true;};
      };
    };

    bash.initExtra = "source <(${dms} completion bash)";
    fish.interactiveShellInit = lib.mkAfter "${dms} completion fish | source";
    zsh.initContent = "source <(${dms} completion zsh)";
  };

  home.packages = with pkgs; [libqalculate]; # for calculator plugin

  wayland.windowManager.hyprland.settings = {
    source = [
      "~/.config/hypr/dms/binds.conf"
      "~/.config/hypr/dms/layout.conf"
      "~/.config/hypr/dms/outputs.conf"
      "~/.config/hypr/dms/windowrules.conf"
    ];
    bind = [
      "SUPER, SPACE, exec, dms ipc launcher toggle"
      # "SUPER, PERIOD, exec, dms ipc launcher toggleWith "
      "SUPER, BACKSPACE, exec, dms ipc powermenu toggle"
      "SUPER, V, exec, dms ipc clipboard toggle"
      "SUPER, D, exec, dms ipc dash toggle \"\""
      "SUPER, W, exec, dms ipc notepad toggle"
      "SUPER, N, exec, dms ipc notifications toggle"
      "SUPER, X, exec, dms ipc notifications dismissAllPopups"
      "SUPER, P, exec, dms ipc color-picker toggle"
      "SUPER, R, exec, dms ipc workspace-rename toggle"
      "SUPER, A, exec, dms ipc hypr toggleOverview"
      "SUPER SHIFT, /, exec, dms ipc keybinds toggle hyprland"
      "SUPER, C, exec, dms ipc control-center toggle"
      "SUPER, I, exec, dms ipc settings toggle"
      ", print, global, dms screenshot full --no-file"
      "ALT, print, global, dms screenshot window --no-file"
      "CTRL, print, global, dms screenshot region --no-file"
      "SUPER, print, global, dms screenshot full"
      "ALT SUPER, print, global, dms screenshot window"
      "CTRL SUPER, print, global, dms screenshot region"
    ];
  };
}
