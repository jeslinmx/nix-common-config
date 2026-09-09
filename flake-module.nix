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
    subsystemOptions = name: displayName: enable: {
      enable = mkEnableOption "${displayName} module and config autodetection" // {default = enable;};
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
    nixos = subsystemOptions "nixos" "NixOS" true;
    home-manager = subsystemOptions "home-manager" "Home Manager" (inputs ? "home-manager");
    darwin = subsystemOptions "darwin" "nix-darwin" (inputs ? "nix-darwin");
    nvf = subsystemOptions "nvf" "nvf (neovim)" (inputs ? "nvf");
  };
  config = let
    inherit (import ./lib.nix lib) gatherModules;
    composeOptions = output: system: type: post: let
      opts = cfg.${system}.${type};
    in
      lib.optionalAttrs opts.enable {
        ${output} =
          if lib.pathExists opts.directory
          then
            opts.directory
            |> gatherModules (cfg.extraArgs // cfg.${system}.extraArgs // cfg.${type}.extraArgs // opts.extraArgs)
            |> post
          else {};
      };
  in {
    flake = lib.mkMerge [
      (composeOptions "darwinModules" "darwin" "modules" (x: x))
      (composeOptions "darwinConfigurations" "darwin" "configurations" (lib.mapAttrs (name: config:
        inputs.nix-darwin.lib.darwinSystem {
          modules = [
            {
              networking.hostName = name;
              nix.nixPath = ["nix-config=${self.outPath}"];
            }
            config
          ];
        })))

      (composeOptions "nixosModules" "nixos" "modules" (x: x))
      (composeOptions "nixosConfigurations" "nixos" "configurations" (lib.mapAttrs (name: config:
        inputs.nixpkgs.lib.nixosSystem {
          system = null;
          modules = [
            {
              networking.hostName = name;
              nix.nixPath = ["nix-config=${self.outPath}"];
            }
            config
          ];
        })))

      (composeOptions "homeModules" "home-manager" "modules" (x: x))
      (composeOptions "homeConfigurations" "home-manager" "configurations" (lib.mapAttrs (
        _: config:
          inputs.home-manager.lib.homeManagerConfiguration {modules = [config];}
      )))

      (composeOptions "nvfModules" "nvf" "modules" (x: x))
    ];

    perSystem = {pkgs, ...}:
      composeOptions "packages" "nvf" "configurations" (lib.mapAttrs' (name: config: {
        name = "neovim-${name}";
        value =
          (inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [config];
          }).neovim;
      }));
  };
}
