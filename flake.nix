{
  description = "NixOS, nix-darwin and home-manager common configuration modules";

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs
    nixpkgs.url = "nixpkgs/release-25.05";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-25.05-darwin";

    # NixOS modules
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin modules
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager modules
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Supporting repos
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    arcwtf = {
      url = "github:kikaraage/arcwtf/v1.3-firefox";
      flake = false;
    };
  };

  outputs = {
    flake-parts,
    devshell,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      lib,
      ...
    }: {
      imports = [
        devshell.flakeModule
      ];

      flake = let
        inherit (self.lib) gatherModules;
      in {
        darwinModules = gatherModules self ./modules/darwin;
        nixosModules = gatherModules self ./modules/nixos;
        homeModules = gatherModules self ./modules/home-manager;

        lib = {
          dirToAttrs = path:
            lib.pipe path [
              builtins.readDir
              (builtins.mapAttrs (
                name: type: let
                  fullPath = /${path}/${name};
                in
                  if type == "directory"
                  then self.lib.dirToAttrs fullPath
                  else fullPath
              ))
            ];
          filterNonNix = lib.filterAttrsRecursive (_: v: !(builtins.isPath v) || lib.hasSuffix ".nix" "${v}");
          filterEmptySubdirs = lib.filterAttrsRecursive (_: v: builtins.isPath v || builtins.length (builtins.attrNames v) != 0);
          flattenAttrs = let
            recurse = sep: prefix:
              lib.foldlAttrs (
                acc: n: v: let
                  fullPath = builtins.concatStringsSep sep (prefix ++ [n]);
                in
                  acc
                  // (
                    if builtins.isPath v
                    then {${fullPath} = v;}
                    else recurse sep [fullPath] v
                  )
              ) {};
          in
            sep: recurse sep [];
          truncateSuffix = lib.mapAttrs' (n: v: lib.nameValuePair (lib.pipe n [(lib.removeSuffix ".nix") (lib.removeSuffix "-default")]) v);
          gatherModules = flake:
            lib.flip lib.pipe [
              self.lib.dirToAttrs
              self.lib.filterNonNix
              self.lib.filterEmptySubdirs
              (self.lib.flattenAttrs "-")
              self.lib.truncateSuffix
              (builtins.mapAttrs (_: import))
              (builtins.mapAttrs (_: v: v flake))
            ];
        };
      };

      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        devshells.default = {
          commands = [
            {
              package = pkgs.nurl;
              category = "dev";
            }
          ];
          packages = [pkgs.nixd];
        };
      };
    });
}
