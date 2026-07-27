{
  self,
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.detect;
in {
  options.detect = let
    inherit (lib) mkEnableOption mkOption types;
    extraArgs = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
    subsystemOptions = name: displayName: {
      enable = mkEnableOption "${displayName} module and config autodetection" // {default = cfg.enable;};
      inherit extraArgs;
      subdirectory = mkOption {
        type = types.str;
        default = name;
      };
      modules = {
        enable = mkEnableOption "${displayName} module autodetection" // {default = cfg.modules.enable && cfg.${name}.enable;};
        inherit extraArgs;
        directory = mkOption {
          type = types.path;
          default = "${cfg.modules.directory}/${cfg.${name}.subdirectory}";
        };
      };
      configurations = {
        enable = mkEnableOption "${displayName} config autodetection" // {default = cfg.configurations.enable && cfg.${name}.enable;};
        inherit extraArgs;
        directory = mkOption {
          type = types.path;
          default = "${cfg.configurations.directory}/${cfg.${name}.subdirectory}";
        };
      };
    };
  in {
    enable = mkEnableOption "module and config autodetection" // {default = true;};
    inherit extraArgs;
    baseDirectory = mkOption {
      type = types.path;
      default = "${self.outPath}";
    };
    modules = {
      enable = mkEnableOption "(NixOS, nix-darwin, etc.) module autodetection" // {default = cfg.enable;};
      inherit extraArgs;
      directory = mkOption {
        type = types.path;
        default = "${cfg.baseDirectory}/modules";
      };
    };
    configurations = {
      enable = mkEnableOption "(NixOS, nix-darwin, etc.) config autodetection" // {default = cfg.enable;};
      inherit extraArgs;
      directory = mkOption {
        type = types.path;
        default = "${cfg.baseDirectory}/configurations";
      };
    };
    nixos = subsystemOptions "nixos" "NixOS";
    home-manager = subsystemOptions "home-manager" "Home Manager";
    darwin = subsystemOptions "darwin" "nix-darwin";
    nvf = subsystemOptions "nvf" "nvf (neovim)";
  };
  config.flake = let
    inherit (import ./lib.nix lib) gatherModules;
    composeOptions = system: type: post: let
      opts = cfg.${system}.${type};
    in
      lib.mkIf opts.enable (
        if lib.pathExists opts.directory
        then
          opts.directory
          |> gatherModules (cfg.extraArgs // cfg.${system}.extraArgs // cfg.${type}.extraArgs // opts.extraArgs)
          |> post
        else {}
      );
  in {
    darwinModules = composeOptions "darwin" "modules" (x: x);
    darwinConfigurations = composeOptions "darwin" "configurations" (lib.mapAttrs (name: config:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [
          {
            networking.hostName = name;
            nix.nixPath = ["nix-config=${self.outPath}"];
          }
          config
        ];
      }));

    nixosModules = composeOptions "nixos" "modules" (x: x);
    nixosConfigurations = composeOptions "nixos" "configurations" (lib.mapAttrs (name: config:
      lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            networking.hostName = name;
            nix.nixPath = ["nix-config=${self.outPath}"];
          }
          config
        ];
      }));

    homeModules = lib.mkIf cfg.home-manager.modules.enable (gatherModules (cfg.extraArgs // cfg.home-manager.extraArgs // cfg.modules.extraArgs // cfg.home-manager.modules.extraArgs) cfg.home-manager.modules.directory);
    nvfModules = lib.mkIf cfg.nvf.modules.enable (gatherModules (cfg.extraArgs // cfg.nvf.extraArgs // cfg.modules.extraArgs // cfg.nvf.modules.extraArgs) cfg.nvf.modules.directory);
  };
}
