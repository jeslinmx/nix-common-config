{
  description = "NixOS, nix-darwin and home-manager common configuration modules";

  nixConfig.extra-substituters = ["https://nvf.cachix.org/"];

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";

    # nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # NixOS modules
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin modules
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager modules
    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
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
    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flake-parts,
    nvf,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({self, ...}: {
      flake = let
        inherit (self.lib) gatherModules;
      in {
        lib = import ./lib.nix inputs;

        darwinModules = gatherModules self ./modules/darwin;
        nixosModules = gatherModules self ./modules/nixos;
        homeModules = gatherModules self ./modules/home-manager;
        nvfModules = gatherModules self ./modules/nvf;
      };

      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {
        system,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;
        packages = let
          nvfConf = nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [self.nvfModules.default];
          };
        in {inherit (nvfConf) neovim;};
        apps = {
          nvim = {
            type = "app";
            program = self.packages.${system}.neovim;
          };
        };
      };
    });
}
