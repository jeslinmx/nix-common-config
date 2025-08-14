{inputs, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.caelestia-shell = {
    enable = lib.mkEnableOption "caelestia-shell";
    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.caelestia-shell.packages.${pkgs.system}.default.override {withCli = true;};
    };
    cliPackage = lib.mkOption {
      type = lib.types.package;
      default = inputs.caelestia-shell.inputs.caelestia-cli.packages.${pkgs.system}.caelestia-cli;
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
    };
  };

  config = let
    cfg = config.programs.caelestia-shell;
  in
    lib.mkIf cfg.enable {
      programs.quickshell = {
        enable = true;
        package = cfg.package;
        systemd.enable = true;
      };
      home.packages = [cfg.cliPackage];
      xdg.configFile."caelestia/shell.json" = {
        text = builtins.toJSON cfg.settings;
        # onChange = "systemctl --user restart quickshell.service";
      };
    };
}
